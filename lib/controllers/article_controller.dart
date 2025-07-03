
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

// state untuk detail artikel
Article? _selectedArticle;
  Article? get selectedArticle => _selectedArticle;

  bool _isDetailLoading = false;
  bool get isDetailLoading => _isDetailLoading;

  String? _detailErrorMessage;
  String? get detailErrorMessage => _detailErrorMessage;

  // --- TAMBAHAN: STATE BARU UNTUK LIKES ---
  int? _likesCount;
  int? get likesCount => _likesCount;
  // ----------------------------------------

// Status like user ini, bisa null saat pertama kali load
  bool? _isLikedByCurrentUser;
  bool? get isLikedByCurrentUser => _isLikedByCurrentUser;

  // Flag untuk mencegah user nge-spam tombol like
  bool _isLikingInProgress = false;
  bool get isLikingInProgress => _isLikingInProgress;


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

  // --- FUNGSI BARU UNTUK FETCH DETAIL ARTIKEL ---
   Future<void> fetchArticleBySlug(String slug) async {
    _isDetailLoading = true;
    _detailErrorMessage = null;
    // Reset data sebelumnya
    _selectedArticle = null;
    _likesCount = null;
    notifyListeners();

    try {
      // Jalankan kedua request API secara paralel biar lebih cepat!
      final responses = await Future.wait([
        _contentService.getPostDetail(slug),
        _contentService.getLikesCount(slug),
      ]);

      // Ambil dan parse response detail artikel
      final articleResponse = responses[0];
      _selectedArticle = Article.fromJsonDetail(articleResponse.data);

      // Ambil dan parse response jumlah likes
      final likesResponse = responses[1];
      _likesCount = likesResponse.data['likes'];

    } on DioException catch (e) {
      _detailErrorMessage = e.response?.data['message'] ?? e.message ?? "Failed to load article data.";
    } catch (e) {
      _detailErrorMessage = "Terjadi kesalahan tidak terduga: $e";
    } finally {
      _isDetailLoading = false;
      notifyListeners();
    }
  }

 /// Fungsi utama untuk handle aksi Like & Unlike dari UI.
  Future<void> toggleLikeStatus(String slug) async {
    if (_isLikingInProgress) return; // Kalau lagi proses, jangan lakuin apa-apa

    _isLikingInProgress = true;
    notifyListeners(); // Update UI untuk disable tombol (jika perlu)

    try {
      // =============================================================
      // JURUS ANDALAN: Jika kita belum tahu status like-nya (null)
      // =============================================================
      if (_isLikedByCurrentUser == null) {
        try {
          // 1. Selalu coba untuk LIKE dulu
          await _contentService.likePost(slug);
          // Kalau berhasil, berarti statusnya jadi 'true' (sudah nge-like)
          _isLikedByCurrentUser = true;
          _likesCount = (_likesCount ?? 0) + 1; // Tambah 1 ke total likes
        } on DioException catch (e) {
          // 2. Kalau gagal karena conflict (409), artinya user SUDAH pernah like.
          // Niat user sebenarnya adalah UNLIKE.
          if (e.response?.statusCode == 409) {
            await _contentService.unlikePost(slug); // Lakukan proses unlike
            _isLikedByCurrentUser = false; // Statusnya jadi 'false'
            _likesCount = (_likesCount ?? 1) - 1; // Kurangi 1
          } else {
            rethrow; // Kalau errornya bukan 409, lempar lagi biar ditangkap di bawah
          }
        }
      } else {
        // =============================================================
        // Logic normal jika status sudah diketahui (Optimistic Update)
        // =============================================================
        final originalLikeStatus = _isLikedByCurrentUser;
        final originalLikesCount = _likesCount;

        // Langsung ubah UI
        _isLikedByCurrentUser = !_isLikedByCurrentUser!;
        _isLikedByCurrentUser! ? _likesCount = (_likesCount! + 1) : _likesCount = (_likesCount! - 1);
        notifyListeners();

        // Kirim request ke API
        if (_isLikedByCurrentUser!) {
          await _contentService.likePost(slug);
        } else {
          await _contentService.unlikePost(slug);
        }
      }
    } catch (e) {
      // Jika terjadi error di mana pun, fetch ulang jumlah like biar data tetap sinkron.
      try {
        final likesResponse = await _contentService.getLikesCount(slug);
        _likesCount = likesResponse.data['likes'];
        // Status isLiked-nya tidak kita ubah, biarkan UI-nya kembali seperti state terakhir yang valid
      } catch (_) {
        // Abaikan jika fetch ulang juga gagal
      }
    } finally {
      _isLikingInProgress = false;
      notifyListeners(); // Update UI untuk re-enable tombol
    }
  }

  /// Membersihkan state halaman detail saat user keluar.
  void clearSelectedArticle() {
    _selectedArticle = null;
    _likesCount = null;
    _isLikedByCurrentUser = null;
  }
  // --- FUNGSI HELPER JUGA DI-UPGRADE ---
  
}