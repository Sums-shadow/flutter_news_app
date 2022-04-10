import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:provider/provider.dart' hide ErrorBuilder;

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
          physics: BouncingScrollPhysics(),
          isScrollable: true,
          /// Para calcular correctamente el painter del Custom Indicator
          labelStyle: TextStyle(height: 1.0),
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
              /// Para setear un ancho fijo para todas las tabs (sin incluid el paddin entre estas)
              // width: 100,
              child: Tab(
                text: category.key.replaceRange(0, 1, category.key[0].toUpperCase()),

                /// Propieades para el CircularIndicator
                // icon: FaIcon(category.value),
                // iconMargin: const EdgeInsets.only(bottom: 10.0 + _padding)
                
                /// Propiedades para el IconBackground
                icon: DecoratedBox(
                  decoration: BoxDecoration(color: Colors.white24, shape: BoxShape.circle),
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
          child: Listener(
              onPointerMove: (event) {
                final offset = event.delta.dx;
                final index = _tabController.index;

                if(((offset > 0 && index == 0) || (offset < 0 && index == _categories.length - 1)) && !_physicsNotifier.value){
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
            child: ValueListenableBuilder<bool>(
              valueListenable: _physicsNotifier,
              builder: (_, value, __) {
                return TabBarView(
                  controller: _tabController,
                  physics: value ? NeverScrollableScrollPhysics() : null,
                  children: List.generate(_categories.length, (index) {
                    return _CategoryTab(index: index);
                  })
                );
              },
            ),
          ),
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

    /// Probar el la propiedad del selector para ver si se pueden redibujar al cambiar un elemento en
    /// espefico de un arreglo
    return Consumer<NewsProvider>(
      builder: (_, newsProvider, __) {
        final error = newsProvider.categoryHeadlines[widget.index].error;
        
        if(error != null) {
          return ErrorBuilder(
            error: error, 
            onTap: () => context.read<NewsProvider>().getCategoryHeadlines(widget.index)
          );
        }

        return NewsList(
          news: newsProvider.categoryHeadlines[widget.index].articles, 
          onEnd: () => context.read<NewsProvider>().getCategoryHeadlines(widget.index)
        );
      }
    );
  }

  @override
  bool get wantKeepAlive => true;
}

