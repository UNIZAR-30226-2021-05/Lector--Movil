import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book.dart';

String apiUrlGetAllBooks = "https://lectorbrainbook.herokuapp.com/libro/todos/";
String apiUrlGetTextFromBook =
    "https://lectorbrainbook.herokuapp.com/libro/offset/Don_Quijote_de_la_Mancha-Cervantes_Miguel.epub";

//TODO: ACTUALIZAR URL READING BOOKS
String apiUrlGetReadingBooks = "https://lectorbrainbook.herokuapp"
    ".com/libro/todos/";
/*
  Devuelve una lista con los libros que está leyendo el
  usuario "user"
 */
Future<List<Book>> GetBooksReading() async {
  List<Book> readingBooks = [];
  SessionManager s = new SessionManager();
  String key = await s.getKey();
  //TODO:Llamar a parser, recibir un Map e iterar

  //Simulación de libros recibidos
  /*for (var i = 0; i < 10; i += 1) {
    readingBooks.add(Book(
        //Al título se le concatena el índice, (hasta obtener los libros
        //del backend). Esto se hace para que el título de cada libro devuelto
        // sea único y así funcione el widget "Hero" (animación entre
        // pantallas)
        "123456789",
        "The Arrivals" + i.toString(),
        "Patrick Jordan",
        "https://d1csarkz8obe9u.cloudfront"
            ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
        'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
            ' paseando cuando derepente...'));
    // ["accion", "comedia"]));
  }*/
  Uri myUri = Uri.parse(apiUrlGetReadingBooks);
  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  print(jsonResponse);

  readingBooks = (json.decode(response.body) as List)
      .map((data) => Book.fromJson(data))
      .toList();
  return readingBooks;
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
        "123456789",
        "The Arrivals" + i.toString(),
        "Patrick Jordan",
        "url.com",
        "https://d1csarkz8obe9u.cloudfront"
            ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
        'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
            ' paseando cuando derepente...'));
    // ["accion", "comedia"]));
  }
  return savedBooks;
}

//Devuelve una lista de los libros que tiene el usuario de acuerdo con la busqueda
List<Book> getBooksSearched(String username, String book) {
  List<Book> booksSearched = [];
  List<Book> libros = [];
  //TODO:Llamar a parser, recibir un Map e iterar

  //Simulación de libros recibidos
  for (var i = 0; i < 10; i += 1) {
    Book libro = Book(
        //Al título se le concatena el índice, (hasta obtener los libros
        //del backend). Esto se hace para que el título de cada libro devuelto
        // sea único y así funcione el widget "Hero" (animación entre
        // pantallas)
        "123456789",
        "The Arrivals" + i.toString(),
        "Patrick Jordan",
        "url.com",
        "https://d1csarkz8obe9u.cloudfront"
            ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
        'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
            ' paseando cuando derepente...');
    // ["accion", "comedia"]));
    libros.add(libro);
  }
  for (var i = 0; i < 10; i += 1) {
    String titulo = libros[i].title;
    if (titulo.toLowerCase().contains(book.toLowerCase())) {
      booksSearched.add(libros[i]);
    }
  }
  return booksSearched;
}

//Lista los libros que coinciden con book

Future<List<Book>> getBooksDiscover(String book) async {
  List<Book> discoverBooks = []; //Aqui se introducen aquellos que coinciden
  List<Book> libros = []; //Aqui se reciben todos los libros
  //TODO:Llamar a parser, recibir un Map e iterar

  SessionManager s = new SessionManager();
  String key = await s.getKey();

  apiUrlGetAllBooks = apiUrlGetAllBooks;
  Uri myUri = Uri.parse(apiUrlGetAllBooks);

  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  print(jsonResponse);

  libros = (json.decode(response.body) as List)
      .map((data) => Book.fromJson(data))
      .toList();

//ESTO ES UNA SIMULACION PARA PODER VER LOS LIBROS DE ALGUNA MANERA

  // //Simulación de libros recibidos
  // for (var i = 0; i < 10; i += 1) {
  //   Book libro = Book(
  //       //Al título se le concatena el índice, (hasta obtener los libros
  //       //del backend). Esto se hace para que el título de cada libro devuelto
  //       // sea único y así funcione el widget "Hero" (animación entre
  //       // pantallas)
  //       "123456789",
  //       "The Arrivals" + i.toString(),
  //       "Patrick Jordan",
  //       "https://d1csarkz8obe9u.cloudfront"
  //           ".net/posterpreviews/sci-fi-book-cover-template-a1ec26573b7a71617c38ffc6e356eef9_screen.jpg?ts=1561547637",
  //       'Hace mucho tiempo en una ciudad muy lejana un niño se encontraba'
  //           ' paseando cuando derepente...',
  //       ["accion", "comedia"]);
  //   libros.add(libro);
  // }

  for (var i = 0; i < libros.length; i += 1) {
    String titulo = libros[i].title;
    if (titulo.toLowerCase().contains(book.toLowerCase())) {
      discoverBooks.add(libros[i]);
    }
  }
  return discoverBooks;
}

//-------------------
// COLECCIONES
//-------------------
//TODO: utilizar "collections" para cachear en un futuro
//TODO: UPDATE de nombre de colección.
//TODO: DELETE de colección.
//TODO: ADD de libros  a colección
//TODO: DELETE de libros pertenecientes a colección

//Simulación almacenamiento colecciones
Map collections = new Map<String, List<Book>>();

//Lista con el nombre de las colecciones del usuario "username".
List<String> GetCollections(String username) {
  //Simulación de colecciones recibidas
  print("bookFacade-getCollections");
  print(collections.keys);
  List<String> collectionsName = collections.keys.toList();
  return collectionsName;
}

//Lista de libros de la colección llamada "collectionName" de usuario "username"
List<Book> GetCollectionBooks(String username, String collectionName) {
  //Simulacion de coleccion devuelta
  return collections[collectionName];
}

//Crear nueva colección "colection" con libros "books" para el usuario "username"
void PostCollection(String username, String collection, List<Book> books) {
  //Simulación de creación de colección
  print("bookFacade-postcollection");
  print(collection);
  collections[collection] = books;
}

//Renombrar la coleccion "Oldcollection" del usuario "username" por
// "NewCollectionName
void RenameCollection(
    String username, String OldCollectionName, String NewCollectionName) {
  //Simulación renombrar colección
  List<Book> collectionBooks = [];
  collectionBooks = collections[OldCollectionName];
  collections.remove(OldCollectionName);
  collections[NewCollectionName] = collectionBooks;
}

//Eliminar la coleccion "collectionName" del usuario "username"
void DeleteCollection(String username, String collectionName) {
  //Simulación renombrar colección
  collections.remove(collectionName);
}

void deleteBookFromUser(String isbn) async {
  SessionManager s = new SessionManager();
  String nombreUsuario = await s.getNombreUsuario();

  print("Se  va a borrar el libro: " + isbn + " del usuario: " + nombreUsuario);
}

void addBookFromUser(String isbn) async {
  SessionManager s = new SessionManager();
  String nombreUsuario = await s.getNombreUsuario();

  print("Se  va a añadir el libro: " + isbn + " al usuario: " + nombreUsuario);
}

Future<String> getText(String path, int currentOffset, int offset,
    int realCharacters, int finalOffset) async {
  SessionManager s = new SessionManager();
  String key = await s.getKey();
  String texto = "";
  String url = apiUrlGetTextFromBook +
      "/" +
      currentOffset.toString() +
      "/" +
      offset.toString();
  print("Esto es donde voy a pedirrrrrrrr " + url);

  Uri myUri = Uri.parse(url);

  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  if (response.statusCode == 200) {
    var jsonResponse = null;
    jsonResponse = json.decode(response.body);
    print(jsonResponse);
    texto = jsonResponse['text'];
    return texto;
  } else {
    return null;
  }
}
