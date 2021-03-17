import 'package:flutter/material.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/home_page.dart';
import 'package:libros/src/pages/library_page.dart';
import 'package:libros/src/pages/registration_page.dart';
import 'package:libros/src/pages/reading_page.dart';
import 'package:libros/src/pages/search_page.dart';
import 'package:libros/src/pages/profile_page.dart';

Map<String, WidgetBuilder> getPages() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => FirstPage(),
    'register': (BuildContext context) => RegisterPage(),

    //HomePage se encarga internamente de hacer slide entre
    //ReadingPage, LibraryPage, SearchPage y ProfilePage.
    //Permite que la barra de navegación sea consistente ¡!
    'home' : (BuildContext context) => HomePage(),
  };
}
