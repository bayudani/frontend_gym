
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/article_models.dart';
import 'package:gym_app/service/content_service.dart'; 

class ArticleController extends ChangeNotifier {
  // --- 2. Ganti dependency ke ContentService ---
  final ContentService _contentService = ContentService();

  List<Article> _articles = [];
  List<Article> get articles => _articles;

  List<Article> get latestArticles {
    return _articles.length > 3 ? _articles.sublist(0, 3) : _articles;
  }

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  String? _errorMessage;
  String? get errorMessage => _errorMessage;

  ArticleController() {
    fetchArticles();
  }

  // --- 3. Ubah method fetchArticles ---
  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getPosts();
      // Dio otomatis decode JSON, ambil datanya dari response.data
      final List<dynamic> articleData = response.data;
      _articles = articleData.map((data) => Article.fromJson(data)).toList();
      _articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } on DioException catch (e) {
      _errorMessage = e.response?.data['message'] ?? e.message ?? "Failed to load articles.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}