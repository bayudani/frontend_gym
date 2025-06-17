import 'package:flutter/material.dart';
import 'package:gym_app/models/article_models.dart';
import 'package:gym_app/service/api_service.dart';

class ArticleController extends ChangeNotifier {
  final ApiService _apiService = ApiService();

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  List<Article> get latestArticles {
    return _articles.length > 2 ? _articles.sublist(0, 3) : _articles;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ArticleController() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final List<dynamic> articleData = await _apiService.getPosts();
      _articles = articleData.map((data) => Article.fromJson(data)).toList();
      _articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } catch (e) {
      _errorMessage = e.toString();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}