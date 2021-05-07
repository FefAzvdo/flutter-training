import 'package:flutter/material.dart';
import 'package:flutter_training/app/views/home_page_view.dart';
import 'package:flutter_training/app/views/search_page_view.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(brightness: Brightness.dark, fontFamily: 'Roboto'),
      routes: {
        '/home': (context) => MyHomePage(),
        '/search': (context) => SearchPage(),
      },
      home: MyHomePage(),
    );
  }
}
