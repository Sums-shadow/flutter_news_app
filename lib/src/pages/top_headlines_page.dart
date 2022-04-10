import 'package:flutter/material.dart';
import 'package:provider/provider.dart' hide ErrorBuilder;

import '../providers/providers.dart';
import '../widgets/widgets.dart';
import '../models/models.dart';

class TopHeadlinesPage extends StatefulWidget {
  const TopHeadlinesPage({Key? key}) : super(key: key);

  @override
  State<TopHeadlinesPage> createState() => _TopHeadlinesPageState();
}

class _TopHeadlinesPageState extends State<TopHeadlinesPage> with AutomaticKeepAliveClientMixin{
  @override
  Widget build(BuildContext context) {
    super.build(context);

    return Selector<NewsProvider, CategoryState>(
      selector: (_, model) => model.topHeadlines,
      builder: (_, topHeadlines, __) {
        /// El loading puede manejarse con el arreglo vacio
        // if(topHeadlines.fetching) return const Center(child: CircularProgressIndicator());

        if(topHeadlines.error != null) {
          return ErrorBuilder(
            error: topHeadlines.error!, 
            onTap: () => context.read<NewsProvider>().getTopHeadlines()
          );
        }

        return NewsList(
          news: topHeadlines.articles, 
          onEnd: () => context.read<NewsProvider>().getTopHeadlines()
        );
      }, 
    );
  }

  @override
  bool get wantKeepAlive => true;
}