import 'package:equatable/equatable.dart';

import '../models/models.dart';

/// Se utilizo un state para manejar diferentes estados para cada categoria esto lo hace mas flexible que utilizar
/// una sola variable de fetching o error para cada categoria ademas de almacenar su pagina y limite
class CategoryState extends Equatable {
  final List<Article> articles;
  final int page;
  final String name;
  final bool limit;
  final bool fetching;
  final String? error;

  const CategoryState({
    this.articles = const [], 
    this.page = 0, 
    required this.name, 
    this.limit = false,
    this.fetching = false,
    this.error
  });

  CategoryState copyWith({
    List<Article>? articles, 
    int? page, 
    String? name, 
    bool? limit, 
    bool? fetching, 
    String? error,
    bool clear = false
  }) => CategoryState(
    articles: articles ?? this.articles,
    page: page ?? this.page,
    name: name ?? this.name,
    limit: limit ?? this.limit,
    fetching: fetching ?? this.fetching,
    error: clear ? null : error ?? this.error
  );

  /// Al hacer un fetch aumentamos la pagina
  CategoryState fetchingState() => copyWith(page: page + 1, fetching: true, clear: true);

  CategoryState dataState(List<Article> newArticles, int max) {
    final articles = [...this.articles, ...newArticles];
    return copyWith(articles: articles, limit: articles.length >= max - 2);
  }

  /// Si el fetch no fue exitoso volvemos la pagina a su valor inicial
  CategoryState errorState(String error) => copyWith(error: error, fetching: false, page: page - 1);

  /// Solo estas tres propiedades generan un cambio de estado, ya que al cambiar el fetch este cambia
  /// con el page y al cambiar el articles cambia el limit, el name nunca cambia
  @override
  List<Object?> get props => [fetching, articles, error];
}