import 'dart:convert';

import '../models/models.dart';

class HeadlinesResponse {
  final String status;
  final int totalResults;
  final List<Article> articles;
  final String? code;
  final String? message;

  const HeadlinesResponse({
    required this.status, 
    required this.totalResults, 
    required this.articles, 
    this.code, 
    this.message
  });

  factory HeadlinesResponse.fromJson(String str) => HeadlinesResponse.fromMap(json.decode(str));

  factory HeadlinesResponse.fromMap(Map<String, dynamic> json) => HeadlinesResponse(
    status: json["status"],
    totalResults: json["totalResults"],
    articles: List<Article>.from(json["articles"].map((x) => Article.fromMap(x))),
    code: json['code'],
    message: json['message']
  );
}