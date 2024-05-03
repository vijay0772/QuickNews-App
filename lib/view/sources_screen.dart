import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:mp5/API_service/api_call.dart';

class SourcesScreen extends StatefulWidget {
  @override
  _SourcesScreenState createState() => _SourcesScreenState();
}

class _SourcesScreenState extends State<SourcesScreen> {
  List<Map<String, dynamic>> sources = [];
  List<Map<String, dynamic>> filteredSources = [];
  final NewsApi _newsApi = NewsApi();
  TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _getSources();
    _searchController.addListener(() => _filterSources());
  }

  Future<void> _getSources() async {
    try {
      List<Map<String, dynamic>> fetchedSources = await _newsApi.fetchSources();
      setState(() {
        sources = fetchedSources;
        filteredSources = sources;
      });
    } catch (e) {
      print('Error fetching sources: $e');
    }
  }

  void _filterSources() {
    setState(() {
      filteredSources = sources
          .where((source) => source['name']
              .toLowerCase()
              .contains(_searchController.text.toLowerCase()))
          .toList();
    });
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('News Sources'),
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(50),
          child: Padding(
            padding: EdgeInsets.all(8),
            child: TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search Sources...',
                prefixIcon: Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: const Color.fromARGB(255, 116, 69, 69).withOpacity(0.9),
              ),
            ),
          ),
        ),
      ),
      body: Stack(
        children: [
          Image.asset(
            'assets/news_background.jpeg',
            fit: BoxFit.cover,
            width: double.infinity,
            height: double.infinity,
          ),
          BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
            child: Container(
              color: Colors.black.withOpacity(0.4),
              width: double.infinity,
              height: double.infinity,
            ),
          ),
          _buildSourcesList(),
        ],
      ),
    );
  }

  Widget _buildSourcesList() {
    return filteredSources.isEmpty
        ? Center(
            child: CircularProgressIndicator(),
          )
        : ListView.builder(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            itemCount: filteredSources.length,
            itemBuilder: (context, index) {
              final source = filteredSources[index];
              return Card(
                elevation: 4,
                margin: EdgeInsets.symmetric(vertical: 6),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(10),
                ),
                child: ListTile(
                  leading: Icon(Icons.article, color: Colors.blue),
                  title: Text(source['name'],
                      style: TextStyle(fontWeight: FontWeight.bold)),
                  subtitle: Text(source['description']),
                ),
              );
            },
          );
  }
}
