import 'book.dart';

/*
  Devuelve una lista con los libros que está leyendo el
  usuario "user"
 */
List<Book> ReadingBooksList(String username) {
  List<Book> readingBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar

  //Simulación de libros recibidos
  for (var i = 0; i < 10; i += 1) {
    readingBooks.add(Book(
        "The Arrivals",
        "Patrick Jordan",
        "https://d1csarkz8obe9u.cloudfront"
            ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
        'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
            ' paseando cuando derepente...', ["accion","comedia"]));
  }
  return readingBooks;
}

/*
  Devuelve una lista con los libros que guardados por el
  usuario "user"
 */
List<Book> SavedBooksList(String username) {
  List<Book> savedBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar
  //Simulación de libros recibidos
  for (var i = 0; i < 10; i += 1) {
    savedBooks.add(Book(
      "The Arrivals",
      "Patrick Jordan",
      "https://d1csarkz8obe9u.cloudfront"
          ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
      'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
          ' paseando cuando derepente...', ["accion","comedia"]));
  }
  return savedBooks;
}