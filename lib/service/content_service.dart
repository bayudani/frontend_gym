// lib/service/content_service.dart

import 'package:dio/dio.dart';
import 'package:gym_app/service/dio_factory.dart';

class ContentService {
  final Dio _dio = DioFactory.create();

  Future<Response> getPosts() {
    return _dio.get('/posts');
  }

  Future<Response> getPrograms() {
    return _dio.get('/programs');
  }

  Future<Response> getProgramById(String id) {
    return _dio.get('/programs/$id');
  }

  Future<Response> getPostDetail(String slug) {
    return _dio.get('/posts/$slug');
  }

  Future<Response> getLikesCount(String slug) {
    return _dio.get('/likes/$slug/likes');
  }

  Future<Response> likePost(String slug) {
    return _dio.post('/likes/$slug/like');
  }

  Future<Response> unlikePost(String slug) {
    return _dio.post('/likes/$slug/unlike');
  }

  Future<Response> getComments(String slug) {
    return _dio.get('/comment/article/$slug');
  }

  /// Mengirim komentar baru ke API (membutuhkan token).
  Future<Response> postComment(String slug, String commentText) {
    return _dio.post('/comment/article/$slug', data: {'comment': commentText});
  }

  Future<Response> getCommentsCount(String slug) {
    return _dio.get('/comment/article/count/$slug');
  }

  Future<Response> getMemberships() {
    return _dio.get('/memberships');
  }

  Future<Response> getMembershipById(String id) {
    return _dio.get('/memberships/$id');
  }

  // --- METHOD BARU UNTUK MENGAMBIL ITEM REWARD ---
  Future<Response> getItemRewards() {
    return _dio.get('/item-rewards');
  }
}
