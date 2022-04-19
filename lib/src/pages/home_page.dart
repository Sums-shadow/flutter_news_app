import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../pages/pages.dart';
import '../widgets/widgets.dart';
import '../providers/providers.dart';

class HomePage extends StatelessWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        /// [Workaround] para poder asignal el [BouncinScrollPhysics] con el PageView y TabBar
        child: Selector<UIProvider, bool>(
          selector: (_, model) => model.stopPhysics,
          builder: (_, value, __) {
            return PageView(
              controller: context.read<UIProvider>().pageController,
              // physics: value ?  NeverScrollableScrollPhysics() : BouncingScrollPhysics(),
              onPageChanged: (int index) => context.read<UIProvider>().page = index,
              children:  const [
                TopHeadlinesPage(),
                CategoryHeadlinesPage(),
              ],
            );
          },
        )
      ),
      bottomNavigationBar: const NewsNavigationBar()
    );
  }
}



