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
      final List<Map<String, dynamic>> news = await _newsApi.fetchNews(category);
      setState(() {
        _newsData = news;
      });
    } catch (e) {
      print('Error fetching news: $e');
    }
  }

  Future<void> _searchNews(String query) async {
    try {
      final List<Map<String, dynamic>> news =
          await _newsApi.serachArtical(query);
      setState(() {
        _newsData = news;
      });
    } catch (e) {
      print('Error searching news: $e');
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

  Widget _buildCategoryGrid() {
    const categories = [
      'general', 'business', 'health', 'science',
      'technology', 'entertainment', 'sport'
    ];

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 3,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemCount: categories.length,
      itemBuilder: (context, index) {
        final category = categories[index];
        return ElevatedButton(
          onPressed: () {
            _fetchNews(category);
            setState(() {
              selectedCategory = category;
            });
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: selectedCategory == category
                ? Color.fromARGB(255, 231, 225, 225)
                : Color.fromARGB(255, 135, 46, 46),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15.0),
            ),
          ),
          child: Text(
            category.toUpperCase(),
            style: const TextStyle(
              color: Color.fromARGB(255, 0, 0, 0),
              fontWeight: FontWeight.bold,
            ),
          ),
        );
      },
    );
  }

  Widget _buildSearchBar() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(25.0),
          gradient: const LinearGradient(
            colors: [Colors.blueAccent, Color.fromARGB(233, 166, 59, 59)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
          child: Row(
            children: [
              const Icon(Icons.search, color: Colors.white),
              const SizedBox(width: 10),
              Expanded(
                child: TextField(
                  controller: _searchController,
                  decoration: const InputDecoration(
                    hintText: 'Search news articles',
                    hintStyle: TextStyle(color: Colors.white70),
                    border: InputBorder.none,
                  ),
                  style: const TextStyle(color: Colors.white),
                  onSubmitted: _searchNews,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNewsList() {
    return _newsData.isEmpty
        ? const Center(child: CircularProgressIndicator())
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.all(12),
            itemCount: _newsData.length,
            itemBuilder: (context, index) {
              final article = _newsData[index];
              return GestureDetector(
                onTap: () {
                  _navigateToArticleDetails(article);
                },
                child: Card(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  elevation: 5,
                  child: NewsCard(
                    imgUrl: article['urlToImage'] ?? '',
                    title: article['title'] ?? 'No Title',
                    desc: article['description'] ?? 'No Description',
                    content: article['content'] ?? '',
                    postUrl: article['url'] ?? '',
                  ),
                ),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('QuickNews'),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _fetchNews(selectedCategory);
            },
          ),
        ],
      ),
      drawer: Drawer(
        child: ListView(
          children: [
            const DrawerHeader(
              decoration: BoxDecoration(
                color: Color.fromARGB(2233, 166, 59, 59),
              ),
              child: Text(
                'News Reader',
                style: TextStyle(
                  color: Colors.white,
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
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildSearchBar(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildCategoryGrid(),
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 8),
                child: Text(
                  'News',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              _buildNewsList(),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _fetchNews(selectedCategory),
        child: const Icon(Icons.refresh),
      ),
    );
  }
}
