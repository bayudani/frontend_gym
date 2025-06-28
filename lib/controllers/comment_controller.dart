// lib/controllers/comment_controller.dart

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

  /// Fetch semua komentar untuk sebuah artikel
  Future<void> fetchComments(String slug) async {
    _isLoading = true;
    notifyListeners();
    try {
      final response = await _contentService.getComments(slug);
      final List<dynamic> commentData = response.data;
      // Parsing dengan model baru, auto-magically works!
      _comments = commentData.map((data) => Comment.fromJson(data)).toList();
      _comments.sort((a, b) => b.createdAt.compareTo(a.createdAt));
    } catch (e) {
      print('Gagal fetch komentar: $e');
      _comments = []; // Kosongkan list jika gagal
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
      // --- STRATEGI BARU: FETCH ULANG SEMUA KOMENTAR ---
      // Ini cara paling aman untuk memastikan data konsisten.
      await fetchComments(slug);
      return true; // Berhasil
    } catch (e) {
      print('Gagal post komentar: $e');
      return false; // Gagal
    } finally {
      _isPosting = false;
      notifyListeners();
    }
  }

  /// Membersihkan list komentar saat pindah halaman
  void clearComments() {
    _comments = [];
  }
}