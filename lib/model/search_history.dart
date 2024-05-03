import 'package:shared_preferences/shared_preferences.dart';

class SearchHistoryService {
  static const _searchKey = 'search_history';

  Future<List<String>> getSearchHistory() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    return prefs.getStringList(_searchKey) ?? [];
  }

  Future<void> addToSearchHistory(String query) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> searchHistory = await getSearchHistory();
    searchHistory.insert(0, query);
    await prefs.setStringList(_searchKey, searchHistory);
  }
}
