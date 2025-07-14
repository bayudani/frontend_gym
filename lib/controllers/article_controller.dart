import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:gym_app/models/article_models.dart';
import 'package:gym_app/service/content_service.dart';

class ArticleController extends ChangeNotifier {
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

  // state untuk detail artikel
  Article? _selectedArticle;
  Article? get selectedArticle => _selectedArticle;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  String? _detailErrorMessage;
  String? get detailErrorMessage => _detailErrorMessage;

  int? _likesCount;
  int? get likesCount => _likesCount;

  // state comment count
  int? _commentsCount;
  int? get commentsCount => _commentsCount;

  // Status like user ini, bisa null saat pertama kali load
  bool? _isLikedByCurrentUser;
  bool? get isLikedByCurrentUser => _isLikedByCurrentUser;

  // Flag untuk mencegah user nge-spam tombol like
  bool _isLikingInProgress = false;
  bool get isLikingInProgress => _isLikingInProgress;

  ArticleController() {
    fetchArticles();
  }

  Future<void> fetchArticles() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await _contentService.getPosts();
      final List<dynamic> articleData = response.data;
      _articles = articleData.map((data) => Article.fromJson(data)).toList();
      _articles.sort((a, b) => b.publishedAt.compareTo(a.publishedAt));
    } on DioException catch (e) {
      _errorMessage =
          e.response?.data['message'] ??
          e.message ??
          "Failed to load articles.";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fungsi untuk feth detail artikel
  Future<void> fetchArticleBySlug(String slug) async {
    _isDetailLoading = true;
    _detailErrorMessage = null;
    // Reset data sebelumnya
    _selectedArticle = null;
    _likesCount = null;
    _commentsCount = null;
    notifyListeners();

    try {
      final responses = await Future.wait([
        _contentService.getPostDetail(slug),
        _contentService.getLikesCount(slug),
        _contentService.getCommentsCount(slug),
      ]);

      final articleResponse = responses[0];
      _selectedArticle = Article.fromJsonDetail(articleResponse.data);

      final likesResponse = responses[1];
      _likesCount = likesResponse.data['likes'];

      final commentsResponse = responses[2];
      print('DEBUG: Response jumlah komen -> ${commentsResponse.data}');
      _commentsCount = commentsResponse.data['comment'];
    } on DioException catch (e) {
      _detailErrorMessage =
          e.response?.data['message'] ??
          e.message ??
          "Failed to load article data.";
    } catch (e) {
      _detailErrorMessage = "Terjadi kesalahan tidak terduga: $e";
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

  Future<void> toggleLikeStatus(String slug) async {
    if (_isLikingInProgress) return;

    _isLikingInProgress = true;
    notifyListeners();

    try {
      if (_isLikedByCurrentUser == null) {
        try {
          await _contentService.likePost(slug);
          _isLikedByCurrentUser = true;
          _likesCount = (_likesCount ?? 0) + 1;
        } on DioException catch (e) {
          if (e.response?.statusCode == 409) {
            await _contentService.unlikePost(slug);
            _isLikedByCurrentUser = false;
            _likesCount = (_likesCount ?? 1) - 1;
          } else {
            rethrow;
          }
        }
      } else {
        final originalLikeStatus = _isLikedByCurrentUser;
        final originalLikesCount = _likesCount;

        _isLikedByCurrentUser = !_isLikedByCurrentUser!;
        _isLikedByCurrentUser!
            ? _likesCount = (_likesCount! + 1)
            : _likesCount = (_likesCount! - 1);
        notifyListeners();

        if (_isLikedByCurrentUser!) {
          await _contentService.likePost(slug);
        } else {
          await _contentService.unlikePost(slug);
        }
      }
    } catch (e) {
      try {
        final likesResponse = await _contentService.getLikesCount(slug);
        _likesCount = likesResponse.data['likes'];
      } catch (_) {}
    } finally {
      _isLikingInProgress = false;
      notifyListeners();
    }
  }

  /// Membersihkan state halaman detail saat user keluar.
  void clearSelectedArticle() {
    _selectedArticle = null;
    _likesCount = null;
    _isLikedByCurrentUser = null;
    _commentsCount = null;
  }
}
