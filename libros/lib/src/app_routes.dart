import 'package:flutter/material.dart';
import 'package:libros/src/pages/book_page.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/home_page.dart';

Map<String, WidgetBuilder> getPages() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => FirstPage(),
    //HomePage se encarga internamente de hacer slide entre
    //ReadingPage, LibraryPage, SearchPage y ProfilePage.
    //Permite que la barra de navegación sea consistente ¡!
    'home': (BuildContext context) => HomePage(),
    'book':(BuildContext context) => BookPage(),
  };
}
