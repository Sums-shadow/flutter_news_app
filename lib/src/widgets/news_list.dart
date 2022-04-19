import 'package:flutter/material.dart';

import '../models/models.dart';
import '../widgets/widgets.dart';

class NewsList extends StatefulWidget {
  final List<Article> news;
  final Function onEnd;

  const NewsList({Key? key, required this.news, required this.onEnd}) : super(key: key);

  @override
  State<NewsList> createState() => _NewsListState();
}

class _NewsListState extends State<NewsList> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_scrollListener);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  bool _debounce = false;

  void _scrollListener() {
    /// Como este metodo se dispara repetidamente el debounce que hacemos en el provider verificando que el 
    /// fetching no sea true no es suficiente, ya que apenas se obtengan los datos este cambiara a false
    /// y justo cuando comence a redibujar para poner los nuevos elementos se disparar este metodod colocando
    /// el fetching a true y mostrando el loading de nuevo, por esta razon utilizamos un debouncer local que
    /// solo permitira disparar la funcion 1 vez, y para volver a habilitar el debounce o que se pueda disparar
    /// la funcion tenemos varias opciones la primera seria enviar un Future en vez de de una funcion para
    /// poder usar el then y despues de esto si cambiar el estado del debounce pero esto tambien puede ser muy 
    /// lento para esta funcion, la otra solucion que se utilizo es el Future.microtask, esta funcion es muy util
    /// ya que permite ejecutar una funcion una vez termina el build, con esto podemos asegurar que se redibuje
    /// la lista con los nuevos elementos y un nuevo maxExtent que no cumplira con la condicion para cambiar el
    /// debounce y de esta manera controlar efectivamente que esta funcion se dispare solo una vez y no
    /// cause errores de rebuild
    if(_scrollController.position.extentAfter < 400  && !_debounce){
      _debounce = true;
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.news.isEmpty) return const _EmptyBuilder();
    
    Future.microtask(() => _debounce = false);

    return ListView.builder(
      itemCount: widget.news.length,
      physics: const BouncingScrollPhysics(),
      padding: const EdgeInsets.only(top: 8),
      controller: _scrollController,
      itemBuilder: (_, index) {
        final article = widget.news[index];
        return NewsItem(article: article, index: index);
      },
    );
  }
}

class _EmptyBuilder extends StatelessWidget {
  const _EmptyBuilder({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: const [
          Icon(Icons.newspaper, size: 48),
          SizedBox(height: 3.0),
          Text('Empty News')
        ],
      ),
    );
  }
}


