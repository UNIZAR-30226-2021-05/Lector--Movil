import 'book.dart';

/*
  Devuelve una lista con los libros que está leyendo el
  usuario "user"
 */
List<Book> GetBooksReading(String username) {
  List<Book> readingBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar

  //Simulación de libros recibidos
  for (var i = 0; i < 10; i += 1) {
    readingBooks.add(Book(
      //Al título se le concatena el índice, (hasta obtener los libros
      //del backend). Esto se hace para que el título de cada libro devuelto
      // sea único y así funcione el widget "Hero" (animación entre
      // pantallas)
        "The Arrivals" + i.toString(),
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
List<Book> GetBooksSaved(String username) {
  List<Book> savedBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar
  //Simulación de libros recibidos
  for (var i = 0; i < 10; i += 1) {
    savedBooks.add(Book(
      //Al título se le concatena el índice, (hasta obtener los libros
      //del backend). Esto se hace para que el título de cada libro devuelto
      // sea único y así funcione el widget "Hero" (animación entre
      // pantallas)
        "The Arrivals" + i.toString(),
      "Patrick Jordan",
      "https://d1csarkz8obe9u.cloudfront"
          ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
      'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
          ' paseando cuando derepente...', ["accion","comedia"]));
  }
  return savedBooks;
}

//Simulación de colecciones guardadas
Map collections = new Map<String,List<Book>>();
/*
  Devuelve una lista con los nombres de las
  colecciones del usuario
 */
List<String> GetCollections(String username) {
  print("collectionsList");
  //Simulación de colecciones recibidas
  print("bookFacade-getCollections");
  print(collections.keys);
  List<String> collectionsName = collections.keys.toList();
  return collectionsName;
}

/*
  Devuelve una lista con los libros pertenecientes a una
  colección del usuario
 */
List<Book> GetCollectionBooks(String username, String collection) {
  //Simulacion de coleccion devuelta
  return collections[collection];
}

/*
  Crea una nueva colección para el usuario
 */
void PostCollection(String username, String collection, List<Book> books) {
  //Simulación de creación de colección
  print("bookFacade-postcollection");
  print(collection);
  collections[collection] = books;
}