import 'package:flutter/material.dart';

class UIProvider extends ChangeNotifier {
  final pageController = PageController();

  int _page = 0;

  int get page => _page;

  set page(int value) {
    if (_page == value) return;
    _page = value;
    
    pageController.animateToPage(value, duration: const Duration(milliseconds: 250), curve: Curves.easeOut);
    notifyListeners();
  }

  /// Para el [workaround] de utilizar el [PageView] con el [TabBar] y [BouncingScrollPhysiscs]
  bool _stopPhysics = false;
  bool get stopPhysics => _stopPhysics;
  set stopPhysics(bool stopPhysics) {
    _stopPhysics = stopPhysics;
    notifyListeners();
  }
}
