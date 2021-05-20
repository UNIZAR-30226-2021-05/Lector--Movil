import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book.dart';

String apiUrlGetAllBooks = "https://lectorbrainbook.herokuapp.com/libro/todos/";
String apiUrlGetTextFromBook =
    "https://lectorbrainbook.herokuapp.com/libro/offset/Don_Quijote_de_la_Mancha-Cervantes_Miguel.epub";

//TODO: ACTUALIZAR URL READING BOOKS
String apiUrlGetReadingBooks =
    "http://lectorbrainbook.herokuapp.com/usuario/guardar/";
/*
  Devuelve una lista con los libros que está leyendo el
  usuario "user"
 */

Future<List<Book>> getBooksReading() async {
  List<Book> readingBooks =
      []; //Aqui se guardan los libros que el usuario esta leyendo

  List<String> isbnLeyendo =
      []; //Aqui voy a guardar los isbn de los libros que se esten leyendo

  List<UserBooks> allUserBooks =
      []; //Aqui se guardan todos los libros del usuario

  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlGetReadingBooks + "alonso");
  http.Response response = await http.get(myUri);
  print(response.body);

  allUserBooks = (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((data) => UserBooks.fromJson(data))
      .toList();

  //Ahora voy a iterar sobre la lista de libros para ver cuales se estan leyendo y añadirlos a la lista de isbnleyendo
  for (int i = 0; i < allUserBooks.length; i++) {
    if (allUserBooks[i].leyendo == true) {
      isbnLeyendo.add(allUserBooks[i].libro);
    }
  }
  //Ahora tengo todos los isbn de los libros que se estan leyendo en la lista isbnLeyendo
  //Se itera en todos los libros extrayendo su informacion, se crea el libro, y se añade a la lista final -> readingBooks
  print(isbnLeyendo.length);
  for (int i = 0; i < isbnLeyendo.length; i++) {
    Book aux = await crearLibro(isbnLeyendo[i]);
    print(isbnLeyendo[i]);
    readingBooks.add(aux);
  }

  return readingBooks;
}

Future<Book> crearLibro(String isbn) async {
  SessionManager s = new SessionManager();
  String key = await s.getKey();
  Book aux;

  String api = "http://lectorbrainbook.herokuapp.com/libro/";

  Uri myUri = Uri.parse(api + isbn);

  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  var jsonResponse = null;
  jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  print(jsonResponse);

  aux = Book.fromJson(jsonResponse);
  return aux;
}

class UserBooks {
  int currentOffset;
  bool leyendo;
  String libro;

  UserBooks({this.currentOffset, this.leyendo, this.libro});

  UserBooks.fromJson(Map<String, dynamic> json) {
    currentOffset = json['currentOffset'];
    leyendo = json['leyendo'];
    libro = json['libro'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentOffset'] = this.currentOffset;
    data['leyendo'] = this.leyendo;
    data['libro'] = this.libro;
    return data;
  }
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
  jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  print(jsonResponse);

  libros = (json.decode(utf8.decode(response.bodyBytes)) as List)
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

// currentOffset: offset de lectura actual
// characters: nº de caracteres pedidos a partir del currentOffset
Future<Map<String, String>> getText(
    String path, int currentOffset, int characters) async {
  Map map = new Map<String, String>();
  SessionManager s = new SessionManager();
  String key = await s.getKey();
  String url = apiUrlGetTextFromBook +
      "/" +
      currentOffset.toString() +
      "/" +
      characters.toString();
  //print("Esto es donde voy a pedirrrrrrrr " + url);

  Uri myUri = Uri.parse(url);

  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  if (response.statusCode == 200) {
    var jsonResponse = null;
    jsonResponse = json.decode(utf8.decode(response.bodyBytes));
    print(jsonResponse);
    map['text'] = jsonResponse['text'];
    map['realCharacters'] = jsonResponse['realCharacters'].toString();
    return map;
  } else {
    return null;
  }
}
