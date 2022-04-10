import 'package:http/http.dart' as http;

import '../models/models.dart';

class NewsService {
  final apiKey = '815f41f756c441f7bc4764a1a01b3aaa';
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