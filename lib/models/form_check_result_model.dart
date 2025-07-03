// Model untuk menampung data hasil analisis form latihan dari AI

class FormCheckResult {
  final bool isCorrect;
  final int score;
  final List<FeedbackPoint> feedbackPoints;
  final String summary;

  FormCheckResult({
    required this.isCorrect,
    required this.score,
    required this.feedbackPoints,
    required this.summary,
  });

  factory FormCheckResult.fromJson(Map<String, dynamic> json) {
    var pointsList = json['feedback_points'] as List;
    List<FeedbackPoint> feedbackPoints = pointsList.map((i) => FeedbackPoint.fromJson(i)).toList();

    return FormCheckResult(
      isCorrect: json['is_correct'] ?? false,
      score: (json['score'] ?? 0).toInt(),
      feedbackPoints: feedbackPoints,
      summary: json['summary'] ?? 'Tidak ada ringkasan.',
    );
  }
}

class FeedbackPoint {
  final String type; // "good" atau "bad"
  final String point;

  FeedbackPoint({required this.type, required this.point});

  factory FeedbackPoint.fromJson(Map<String, dynamic> json) {
    return FeedbackPoint(
      type: json['type'] ?? 'bad',
      point: json['point'] ?? 'Tidak ada feedback.',
    );
  }
}
