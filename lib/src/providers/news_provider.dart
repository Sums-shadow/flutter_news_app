import 'package:flutter/material.dart';

import '../models/models.dart';
import '../services/services.dart';

/// Este tipo de ejemplos de manejan mejor con listas en vez de con [streams], la unica desventaja de esta solucion
/// es que al hacer fetch de una categoria se redibujaran todas cuando se obtengan los resultados (no cuando
/// se pidan porque el loading lo hace el arreglo vacio), se redibujarn todas las [Tabs] debido a que en el
/// [provider] no se puede notificar o filtrar que un elemento especifico de un arreglo se modifico
class NewsProvider extends ChangeNotifier {
  final NewsService _api;

  NewsProvider(this._api) {
    final List<Future<void>> futures = [getTopHeadlines()];

    /// Para cargar las primeras paginas la primera vez
    // for (int i = 0; i < categoryHeadlines.length; i++) {
    //   futures.add(getCategoryHeadlines(i));
    // }

    Future.wait(futures);
  }

  CategoryState topHeadlines = CategoryState(name: 'top');

  List<CategoryState> categoryHeadlines = [
    CategoryState(name: 'business'),    
    CategoryState(name: 'entertainment'),
    CategoryState(name: 'general'),     
    CategoryState(name: 'health'),      
    CategoryState(name: 'science'),      
    CategoryState(name: 'sports'),       
    CategoryState(name: 'technology'),  
    CategoryState(name: 'others'),   
  ];

  Future<void> getTopHeadlines() async {
    if(topHeadlines.fetching || topHeadlines.limit) return;

    /// No notificamos el fetch porque el loading lo representa el arreglo vacio
    topHeadlines = topHeadlines.fetchingState();
    /// Sin embargo si ocurre un error e intentamos mostrar de nuevo el loading, no se mostrara sin esto
    notifyListeners();

    try {
      final headlines = await _api.fetchTopHeadlines(topHeadlines.page);

      topHeadlines = topHeadlines.dataState(headlines.articles, headlines.totalResults);
    } catch (e) {
      print('error: ${e.toString()}');
      topHeadlines = topHeadlines.errorState('error: ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }

  Future<void> getCategoryHeadlines(int i) async {
    if(categoryHeadlines[i].fetching || categoryHeadlines[i].limit) return;
    
    categoryHeadlines[i] = categoryHeadlines[i].fetchingState();
    notifyListeners();

    try {
      final headlines = await _api.fetchCategoryHeadlines(categoryHeadlines[i].name, categoryHeadlines[i].page);
     
      categoryHeadlines[i] = categoryHeadlines[i].dataState(headlines.articles, headlines.totalResults);
    } catch (e) {
      print('error: ${e.toString()}');
      categoryHeadlines[i] = categoryHeadlines[i].errorState('error: ${e.toString()}');
    } finally {
      notifyListeners();
    }
  }
}