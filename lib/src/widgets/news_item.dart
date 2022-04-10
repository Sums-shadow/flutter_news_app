import 'package:flutter/material.dart';

import '../models/models.dart';

class NewsItem extends StatelessWidget {
  final Article article;
  final int index;

  const NewsItem({Key? key, required this.article, required this.index}) : super(key: key);

  static const _indexStyle = TextStyle(fontSize: 14, color: Colors.red);
  static const _sourceStyle = TextStyle(fontSize: 14, color: Colors.white);
  static const _titleStyle = TextStyle(fontSize: 16, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        /// Source
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: RichText(
            text: TextSpan(
              text: '$index. ', 
              style: _indexStyle, 
              children: [TextSpan(text: '$article.source', style: _sourceStyle)]
            )
          )
        ),

        SizedBox(height: 5),

        /// Title
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 12), 
          child: Text('${article.title} ', style: _titleStyle)
        ),

        SizedBox(height: 8),

        /// Image
        SizedBox(
          width: double.infinity,
          height: 200,
          child: _ArticleImage(article.urlToImage)
        ),

        SizedBox(height: 8),
        
        /// Description
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20), 
          child: article.description == null ? const Text('No Description') : Text('${article.description}')
        ),
        
        SizedBox(height: 7),

        /// Actions
        const _ArticleActions(),
      ],
    );
  }
}

class _ArticleImage extends StatelessWidget {
  final String? urlImage;

  const _ArticleImage(this.urlImage, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: const BorderRadius.only(topLeft: Radius.circular(50), bottomRight: Radius.circular(50)),
      child: urlImage == null || !urlImage!.contains('http')
        ? Image(
          image: const AssetImage('assets/no-image.png'),
          fit: BoxFit.cover,
        ) : 
        FadeInImage(
          placeholder: const AssetImage('assets/giphy.gif'), 
          image: NetworkImage(urlImage!), 
          fit: BoxFit.cover
        )
    );
  }
}

class _ArticleActions extends StatelessWidget {
  const _ArticleActions({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        ElevatedButton(
          onPressed: () {}, 
          child: const Icon(Icons.star_border),
          style: ElevatedButton.styleFrom(
            primary: Colors.red,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 25)
          ),
        ),

        SizedBox(width: 10),
        
        ElevatedButton(
          onPressed: () {}, 
          child: const Icon(Icons.more),
          style: ElevatedButton.styleFrom(
            primary: Colors.blue,
            shape: const StadiumBorder(),
            padding: const EdgeInsets.symmetric(horizontal: 25)
          ),
        ),
      ],
    );
  }
}