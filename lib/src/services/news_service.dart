import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

import '../models/models.dart';

class NewsService {
  final apiKey = dotenv.env['NEWS_API_KEY']!;
  final urlBase = 'newsapi.org';

  Future<HeadlinesResponse> fetchTopHeadlines(int page) async {
    final url = Uri.https(urlBase, '/v2/top-headlines', {
      'country': 'co', 
      'apiKey': apiKey, 
      'page': page.toString()
    });

    final response = await http.get(url);

    final headlinesResponse = HeadlinesResponse.fromJson(response.body);
   
    return headlinesResponse;
  }

  Future<HeadlinesResponse> fetchCategoryHeadlines(String category, int page) async {
    final url = Uri.https(urlBase, '/v2/top-headlines', {
      'country': 'co', 
      'apiKey': apiKey, 
      'category': category, 
      'page': page.toString()
    });

    final response = await http.get(url);
      
    final headlinesResponse = HeadlinesResponse.fromJson(response.body);
      
    return headlinesResponse;
  }
}