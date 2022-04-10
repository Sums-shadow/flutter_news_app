import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../providers/providers.dart';

class NewsNavigationBar extends StatelessWidget {
  const NewsNavigationBar({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Selector<UIProvider, int>(
      selector: (_, model) => model.page,
      builder: (_, page, __) {
        return BottomNavigationBar(
          onTap: (int index) => context.read<UIProvider>().page = index,
          currentIndex: page,
          items: const [
            BottomNavigationBarItem(
              icon: Icon(Icons.person_outline),
              label: 'Para ti'
            ),
            BottomNavigationBarItem(
              icon: Icon(Icons.public),
              label: 'Encabezados'
            ),
          ],
        );
      },
    );
  }
}