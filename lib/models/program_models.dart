import 'package:flutter/foundation.dart';

class Program {
  final String id;
  final String name;
  final String description;
  final DateTime createdAt;

  Program({
    required this.id,
    required this.name,
    required this.description,
    required this.createdAt,
  });

  factory Program.fromJson(Map<String, dynamic> json) {
    return Program(
      id: json['id'] ?? '',
      name: json['name'] ?? 'No Name',
      description: json['description'] ?? '',
      createdAt: DateTime.tryParse(json['created_at'] ?? '') ?? DateTime.now(),
    );
  }
}
