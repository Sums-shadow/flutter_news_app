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

  void _scrollListener() {
    if(_scrollController.position.extentAfter < 200){
      widget.onEnd();
    }
  }

  @override
  Widget build(BuildContext context) {
    if(widget.news.isEmpty) return Center(child: CircularProgressIndicator(color: Colors.white));

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


