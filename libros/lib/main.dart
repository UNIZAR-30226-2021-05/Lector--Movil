import 'package:flutter/material.dart';
import 'package:libros/src/app_routes.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainBook',
      // home: HomePage(),
      initialRoute: 'home',
      //initialRoute: '/',
      routes: getPages(),
    );
  }
}
