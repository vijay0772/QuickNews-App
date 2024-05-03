import 'package:http/http.dart' as http;
import 'dart:convert';

class NewsApi {
  final String apiKey = '2b8a9e38a5634ef29dad890e5e6e557c'; // Replace with your actual API key

  Future<List<Map<String, dynamic>>> fetchNews(String category) async {
    final String baseUrl = 'https://newsapi.org/v2/top-headlines';
    final String country = 'us';
    final String url =
        '$baseUrl?country=$country&category=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));
    print(response);
    if (response.statusCode == 200) {
      // Successfully fetched data
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return List<Map<String, dynamic>>.from(data['articles']);
      } else {
        throw Exception('Failed to fetch news: ${data['message']}');
      }
    } else {
      // Failed to fetch data
      throw Exception('Failed to load news');
    }
  }

  Future<List<Map<String, dynamic>>> fetchHeadlines(String category) async {
    final String baseUrl = 'https://newsapi.org/v2/top-headlines';
    final String country = 'us'; // Change this to your desired country code
    final String url =
        '$baseUrl?country=$country&category=$category&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Successfully fetched data
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return List<Map<String, dynamic>>.from(data['articles']);
      } else {
        throw Exception('Failed to fetch news: ${data['message']}');
      }
    } else {
      // Failed to fetch data
      throw Exception('Failed to load news');
    }
  }

  Future<List<Map<String, dynamic>>> serachArtical(String query) async {
    final String baseUrl = 'https://newsapi.org/v2/everything';
    final String url = '$baseUrl?q=$query&apiKey=$apiKey';

    final response = await http.get(Uri.parse(url));

    if (response.statusCode == 200) {
      // Successfully fetched data
      final Map<String, dynamic> data = json.decode(response.body);
      if (data['status'] == 'ok') {
        return List<Map<String, dynamic>>.from(data['articles']);
      } else {
        throw Exception('Failed to fetch news: ${data['message']}');
      }
    } else {
      // Failed to fetch data
      throw Exception('Failed to load news');
    }
  }

  Future<List<Map<String, dynamic>>> fetchSources() async {
    const String baseUrl = 'https://newsapi.org/v2/top-headlines';
    final String url = '$baseUrl/sources?apiKey=$apiKey';

    try {
      final response = await http.get(Uri.parse(url));

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = json.decode(response.body);
        if (data.containsKey('sources')) {
          List<Map<String, dynamic>> sources =
              List<Map<String, dynamic>>.from(data['sources']);
          return sources;
        } else {
          throw Exception('No sources found');
        }
      } else {
        throw Exception('Failed to fetch sources');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}
