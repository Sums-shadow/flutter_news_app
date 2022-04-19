import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' hide ErrorBuilder;

import '../states/states.dart';
import '../providers/providers.dart';
import '../widgets/widgets.dart';
// import '../painters/painters.dart';

class CategoryHeadlinesPage extends StatefulWidget {
  const CategoryHeadlinesPage({Key? key}) : super(key: key);

  @override
  State<CategoryHeadlinesPage> createState() => _CategoryHeadlinesPageState();
}

class _CategoryHeadlinesPageState extends State<CategoryHeadlinesPage> with SingleTickerProviderStateMixin {
  late final TabController _tabController;
  final _physicsNotifier = ValueNotifier<bool>(false);

  static const _categories = {
    'Business'     : FontAwesomeIcons.building,
    'Entertainment': FontAwesomeIcons.tv,
    'General'      : FontAwesomeIcons.addressCard,
    'Health'       : FontAwesomeIcons.headSideVirus,
    'Science'      : FontAwesomeIcons.vials,
    'Sports'       : FontAwesomeIcons.volleyball,
    'Technology'   : FontAwesomeIcons.memory,
    'Others'       : FontAwesomeIcons.accessibleIcon
  };

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: _categories.length, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    _physicsNotifier.dispose();
    super.dispose();
  }

  static const _padding = 5.0;
  static const _radius = 45.0;

  // static const _duration = Duration(milliseconds: 750);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        TabBar(
          controller: _tabController,
          padding: const EdgeInsets.only(top: _padding),
          physics: const BouncingScrollPhysics(),
          isScrollable: true,
          /// Para calcular correctamente el painter del Custom Indicator
          labelStyle: const TextStyle(height: 1.0),
          labelColor: Colors.red,
          unselectedLabelColor: Colors.white,
          overlayColor: MaterialStateProperty.all(Colors.transparent),
          /// CircularIndicator
          // indicator: CustomTabIndicator(
          //   separation: _padding,
          //   radius: _radius
          // ),
          indicatorColor: Colors.transparent,
          tabs: _categories.entries.map((category) {
            return SizedBox(
              // width: 100, //->Ancho fijo para todas (sin incluir padding)
              child: Tab(
                text: category.key,

                /// Propieades para el CircularIndicator
                // icon: FaIcon(category.value),
                // iconMargin: const EdgeInsets.only(bottom: 10.0 + _padding)
                
                /// Propiedades para el IconBackground
                icon: DecoratedBox(
                  decoration: const BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
                  child: SizedBox.square(dimension: _radius, child: Align(child: FaIcon(category.value))),
                ),
                iconMargin: const EdgeInsets.only(bottom: 5.0),
              ),
            );
          }).toList()
        ),
    
        Expanded(
          /// Listener que escucha cuando estemos en la primera o ultima pagina del [TabView] y se intente
          /// pasar de nuevo al [PageView] cambiamos la fisica para poder utilizar estos dos scroll aninados
          /// Se intento hacer con un RawGestureDetector y Gestura arena pero son conceptos aun muy complejos
          /// Una desventaja esque al bajar (verticalDrag) tambien se dispara esto redibujando la lista
          /// aunque unicamente ocurre en la primera y ultima pagina
          child: Listener(
            onPointerMove: (event) {
              final offset = event.delta.dx;
              final index = _tabController.index;

              if(((offset > 0 && index == 0) || (offset < 0 && index == _categories.length - 1)) && (!_physicsNotifier.value)){
                _physicsNotifier.value = true;
              }
            },
            onPointerUp: (event) {
              _physicsNotifier.value = false;
              
              /// Para el [workaround] del [BouncingScrollPhysics]
              // final offset = event.position.direction ;
              //
              // if(_tabController.index == _categories.length - 1 && offset >= 1.0){
              //   if(context.read<UIProvider>().stopPhysics) return;
              //   context.read<UIProvider>().stopPhysics = true;
              //   Future.delayed(_duration, () => context.read<UIProvider>().stopPhysics = false);
              // }
            },
            child:  ValueListenableBuilder<bool>(
              valueListenable: _physicsNotifier,
              builder: (_, value, __) {
                return TabBarView(
                  controller: _tabController,
                  physics: value ? const NeverScrollableScrollPhysics() : null,
                  children: List.generate(_categories.length, (index) {
                    return _CategoryTab(index: index);
                  })
                );
              },
            ),
          )
        )
      ],
    );
  }
}

class _CategoryTab extends StatefulWidget {
  final int index;

  const _CategoryTab({Key? key, required this.index}) : super(key: key);

  @override
  State<_CategoryTab> createState() => _CategoryTabState();
}

/// La ventaja principal del AutomaticKeepLive es que no dispara de nuevo el metodo init del widget,
/// entonces se podria almacenar el estado del tabview (tab activa) si se pusiera este mixin en el padre
/// pero se volveria a ejecutar el initState de cada tab con cada cambio, por esta razon es mejor tenerlo aqui
class _CategoryTabState extends State<_CategoryTab> with AutomaticKeepAliveClientMixin {
  @override 
  void initState() {
    super.initState();

    /// No lo ejecutamos aqui porque el notifyListener del fetching choca con el primer build del widget
    /// Por lo que mejor esperamos que se construya y hay si lanzar la peticion
    // Provider.of<NewsProvider>(context, listen: false).getCategoryHeadlines(widget.index);

    WidgetsBinding.instance!.addPostFrameCallback((_) {
      Provider.of<NewsProvider>(context, listen: false).getCategoryHeadlines(widget.index);
    });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);

    /// Al parecer el selector tambien permite filtrar cambios mas profundos en los provider, por ejemplo
    /// aqui unicamente escuchamos los cambios de un elemento en un arreglo dentro del provider, lo cual 
    /// para este caso es super efectivo, ya que si escucharamos cambios en el arreglo se redibujarian 
    /// todas las pantallas del TabView cuando ocurriera un cambio al una, de esta manera unicamente
    /// escuchamos los cambios en la pantalla activa tanto al cargar la primera pagina como mas paginas,
    /// esto tambien aplica para propiedades de los state pero no se sabe si para mapas o sets
    return Selector<NewsProvider, CategoryState>(
      selector: (_, model) => model.categoryHeadlines[widget.index],
      builder: (_, news, __) {
        if(news.fetching) return const Center(child: CircularProgressIndicator());

        if(news.error != null) {
          return ErrorBuilder(
            error: news.error!, 
            onTap: () => context.read<NewsProvider>().getCategoryHeadlines(widget.index)
          );
        }

        return NewsList(
          news: news.articles, 
          onEnd: () => context.read<NewsProvider>().getCategoryHeadlines(widget.index)
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}