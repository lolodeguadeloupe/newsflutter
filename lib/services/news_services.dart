import 'dart:convert';
import 'package:http/http.dart' as http;
import '../models/article.dart';

class NewsService {
  static const String apiKey = 'c215a334633641f2b888ce717923d9c7';
  static const String baseUrl = 'https://newsapi.org/v2/top-headlines';

  static Future<List<Article>> getArticles(String category) async {
    final response = await http.get(
        Uri.parse('$baseUrl?country=fr&category=$category&apiKey=$apiKey'));

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      return (jsonData['articles'] as List)
          .map((articleJson) => Article.fromJson(articleJson))
          .toList();
    } else {
      throw Exception('Échec du chargement des articles');
    }
  }
}
