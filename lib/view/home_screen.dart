import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:mp5/API_service/api_call.dart';
import 'package:mp5/main.dart';
import 'package:mp5/view/artical_screen.dart';
import 'package:mp5/view/newscard.dart';
import 'package:mp5/view/sources_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final NewsApi _newsApi = NewsApi();
  List<Map<String, dynamic>> _newsData = [];
  String selectedCategory = 'general'; // Default category
  final TextEditingController _searchController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _fetchNews(selectedCategory); // Fetch news data when the screen loads
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  Future<void> _fetchNews(String category) async {
    try {
      final List<Map<String, dynamic>> news =
          await _newsApi.fetchNews(category);
      setState(() {
        _newsData = news;
      });
    } catch (e) {
      print('Error fetching news: $e');
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

  Future<void> _searchNews(String query) async {
    try {
      final List<Map<String, dynamic>> news =
          await _newsApi.serachArtical(query);
      setState(() {
        _newsData = news;
      });
      print("object -----");
    } catch (e) {
      print('Error searching news: $e');
      // Handle error - show a snackbar, display an error message, etc.
    }
  }

  void _navigateToArticleDetails(Map<String, dynamic> article) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ArticleDetailsScreen(article: article),
      ),
    );
  }

  Widget _buildCategoryButton(String category) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4.0),
      child: ElevatedButton(
        onPressed: () {
          _fetchNews(category);
          setState(() {
            selectedCategory = category;
          });
        },
        style: ElevatedButton.styleFrom(
          backgroundColor: selectedCategory == category
              ? const Color.fromARGB(255, 143, 143, 143)
              : const Color.fromARGB(255, 142, 70, 70),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20.0),
          ),
        ),
        child: Text(
          category.toUpperCase(),
          style: TextStyle(
            color: selectedCategory == category ? Colors.white : Colors.black,
          ),
        ),
      ),
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(25.0),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: Row(
            children: [
              const Icon(Icons.search),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search news articles',
                    border: InputBorder.none,
                  ),
                  onSubmitted: (value) {
                    _searchNews(value);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('News Reader'),
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(233, 166, 59, 59),
              ),
              child: Text(
                'News Reader',
                style: TextStyle(
                  color: Color.fromARGB(221, 27, 27, 35),
                  fontSize: 24,
                ),
              ),
            ),
            ListTile(
              title: const Text('News Sources'),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => SourcesScreen()),
                );
              },
            ),
            ListTile(
              title: const Text('Logout'),
              onTap: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(
                      builder: (context) =>
                          const LoginRegisterScreen(isDarkMode: true)),
                );
              },
            ),
          ],
        ),
      ),
      body: Stack(
        children: [
          // Background image
          Image.asset(
            'assets/news_background.jpeg', // Replace with your image path
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          // Blurred background image
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 5, sigmaY: 5),
            child: Container(
              color:
                  const Color.fromARGB(255, 205, 62, 62).withOpacity(0), // Adjust the opacity as needed
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          // Main content
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    _buildCategoryButton('general'),
                    _buildCategoryButton('business'),
                    _buildCategoryButton('health'),
                    _buildCategoryButton('science'),
                    _buildCategoryButton('technology'),
                    _buildCategoryButton('entertainment'),
                    _buildCategoryButton('sport'),
                    // Add more category buttons as needed
                  ],
                ),
              ),
              _newsData.isEmpty
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Expanded(
                      child: ListView.builder(
                        itemCount: _newsData.length,
                        itemBuilder: (context, index) {
                          final article = _newsData[index];
                          return GestureDetector(
                            onTap: () {
                              _navigateToArticleDetails(article);
                            },
                            child: NewsCard(
                              imgUrl: article['urlToImage'] ?? '',
                              title: article['title'] ?? 'No Title',
                              desc: article['description'] ?? 'No Description',
                              content: article['content'] ?? '',
                              postUrl: article['url'] ?? '',
                            ),
                          );
                        },
                      ),
                    ),
            ],
          ),
        ],
      ),
    );
  }
}
