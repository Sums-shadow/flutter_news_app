import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:provider/provider.dart';

import 'src/providers/providers.dart';
import 'src/services/services.dart';
import 'src/pages/pages.dart';
 
void main() async {
  await dotenv.load();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider(create: (_) => NewsService()),
        ChangeNotifierProvider(create: (_) => UIProvider()),
        ChangeNotifierProvider(create: (context) => NewsProvider(context.read<NewsService>()))
      ],
      child: MaterialApp(
        title: 'Material App',
        /// Elimina el glow del scroll al llegar al limite (ripple de color)
        scrollBehavior: const _MyCustomScrollBehavior(),
        debugShowCheckedModeBanner: false,
        home: const HomePage(),
        theme: ThemeData.dark().copyWith(
          colorScheme: const ColorScheme.dark().copyWith(
            primary: Colors.red,
            secondary: Colors.red,
            onPrimary: Colors.white
          )
        ),
      ),
    );
  }
}

class _MyCustomScrollBehavior extends MaterialScrollBehavior {
  const _MyCustomScrollBehavior();

  @override
  Widget buildOverscrollIndicator(BuildContext context, Widget child, ScrollableDetails details) {
    return child;
  }
}