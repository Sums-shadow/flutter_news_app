import 'package:flutter/material.dart';

import '../states/states.dart';
import '../services/services.dart';

/// Este tipo de ejemplos de manejan mejor con listas en vez de con [streams]
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

  CategoryState topHeadlines = const CategoryState(name: 'top');

  /// Como es una lista no podemos usar un setter para activar el notifyListener sino llamarlo manualmente
  /// siempre que haya un cambio en uno de sus elementos por eso se llama en el finally de los metodos
  List<CategoryState> categoryHeadlines = [
    const CategoryState(name: 'business'),    
    const CategoryState(name: 'entertainment'),
    const CategoryState(name: 'general'),     
    const CategoryState(name: 'health'),      
    const CategoryState(name: 'science'),      
    const CategoryState(name: 'sports'),       
    const CategoryState(name: 'technology'),  
    const CategoryState(name: 'others'),   
  ];

  Future<void> getTopHeadlines() async {
    /// Si llegamos al limite de los resultados no podemos agregar mas ya que se repetirian
    if(topHeadlines.fetching || topHeadlines.limit) return;

    /// No notificamos el fetch porque el loading lo representa el arreglo vacio
    topHeadlines = topHeadlines.fetchingState();

    /// Solo si hay un error previo vuelve a mostrar la pantalla de loading
    if(topHeadlines.reload) notifyListeners();

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

    /// Si la categoria viene vacia tambien mostramos el loading de nuevo
    if(categoryHeadlines[i].reload || categoryHeadlines[i].articles.isEmpty) notifyListeners();

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