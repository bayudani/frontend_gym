import 'package:flutter/material.dart';
import 'package:gym_app/models/comment_models.dart';
import 'package:gym_app/service/content_service.dart';

class CommentController extends ChangeNotifier {
  final ContentService _contentService = ContentService();

  List<Comment> _comments = [];
  List<Comment> get comments => _comments;

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  bool _isPosting = false;
  bool get isPosting => _isPosting;

  Future<void> fetchComments(String slug) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _contentService.getComments(slug);
      final List<dynamic> commentData = response.data;
      _comments = commentData.map((data) => Comment.fromJson(data)).toList();
      _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Gagal fetch komentar: $e');
      _comments = [];
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  /// Mengirim komentar baru ke API
  Future<bool> postComment(String slug, String commentText) async {
    _isPosting = true;
    notifyListeners();
    try {
      await _contentService.postComment(slug, commentText);
      await fetchComments(slug);
      return true;
    } catch (e) {
      print('Gagal post komentar: $e');
      return false;
    } finally {
      _isPosting = false;
      notifyListeners();
    }
  }

  void clearComments() {
    _comments = [];
  }
}
