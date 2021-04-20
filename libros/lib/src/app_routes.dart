import 'package:flutter/material.dart';
import 'package:libros/src/pages/book_page.dart';
import 'package:libros/src/pages/collection_books.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/loading_page.dart';
import 'package:libros/src/pages/mainPages/home_page.dart';
import 'package:libros/src/pages/book_details_page.dart';
import 'package:libros/src/pages/collection_add.dart';
import 'package:libros/src/pages/mainPages/library_page.dart';

Map<String, WidgetBuilder> getPages() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => FirstPage(),
    //HomePage se encarga internamente de hacer slide entre
    //ReadingPage, LibraryPage, SearchPage y ProfilePage.
    //Permite que la barra de navegación sea consistente ¡!
    'home': (BuildContext context) => HomePage(),
    'book':(BuildContext context) => BookPage(),
    'bookDetails':(BuildContext context) => BookDetailsPage(),
    'collectionAdd':(BuildContext context) => CollectionAdd(),
    'collectionBooks':(BuildContext context) => CollectionBooks(),
    'library':(BuildContext context) => LibraryPage(),
    'firstPage':(BuildContext context) => FirstPage(),
    'loadingPage' :(BuildContext context) => Loading(),
  };
}
