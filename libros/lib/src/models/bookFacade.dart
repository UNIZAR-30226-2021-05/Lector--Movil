import 'dart:io';

import 'book.dart';
/*
  Devuelve una lista con los libros que está leyendo el
  usuario "user"
 */
List<Book> ReadingBooksList(String username) {
  List<Book> readingBooks= [];
  //TODO:Llamar a parser, recibir un Map e iterar


  //Simulación de libros recibidos
  for(var i=0; i<10; i+=1) {
    readingBooks.add(Book("The Arrivals",
        "https://d1csarkz8obe9u.cloudfront"
            ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
        ''));
  }
  return readingBooks;
}