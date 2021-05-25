import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'book.dart';

String apiUrlGetAllBooks = "https://lectorbrainbook.herokuapp.com/libro/todos/";
String apiUrlGetTextFromBook =
    "https://lectorbrainbook.herokuapp.com/libro/offset/sample1.txt/20/90";
String apiUrlColeccion= "https://lectorbrainbook.herokuapp.com/usuario/coleccion/";
//TODO: ACTUALIZAR URL READING BOOKS
String apiUrlGetReadingBooks =
    "http://lectorbrainbook.herokuapp.com/usuario/guardar/";

String apiAddBookToUser =
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
  Uri myUri = Uri.parse(apiUrlGetReadingBooks + username);
  http.Response response = await http.get(myUri);
  print(response.body);

  allUserBooks = (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((data) => UserBooks.fromJson(data))
      .toList();

  //Ahora voy a iterar sobre la lista de libros para ver cuales se estan leyendo y añadirlos a la lista de isbnleyendo
  for (int i = 0; i < allUserBooks.length; i++) {
    if (allUserBooks[i].leyendo) {
      isbnLeyendo.add(allUserBooks[i].isbn);
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
  String isbn;

  UserBooks({this.currentOffset, this.leyendo, this.isbn});

  UserBooks.fromJson(Map<String, dynamic> json) {
    currentOffset = json['currentOffset'];
    leyendo = json['leyendo'];
    isbn = json['ISBN'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['currentOffset'] = this.currentOffset;
    data['leyendo'] = this.leyendo;
    data['ISBN'] = this.isbn;
    return data;
  }
}

/*
  Devuelve una lista con los libros que guardados por el
  usuario "user"
 */
Future<List<Book>> getBooksSaved(String username) async {
  List<Book> savedBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar
  //Simulación de libros recibidos

  List<UserBooks> allUserBooks =
      []; //Aqui se guardan todos los libros del usuario

  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlGetReadingBooks + username);
  http.Response response = await http.get(myUri);
  print(response.body);

  allUserBooks = (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((data) => UserBooks.fromJson(data))
      .toList();

  for (int i = 0; i < allUserBooks.length; i++) {
    Book aux = await crearLibro(allUserBooks[i].isbn);
    savedBooks.add(aux);
  }
  return savedBooks;
}

//Devuelve una lista de los libros que tiene el usuario de acuerdo con la busqueda
Future<List<Book>> getBooksSearched(String book) async {
  List<Book> savedBooks = [];
  //TODO:Llamar a parser, recibir un Map e iterar
  //Simulación de libros recibidos

  List<UserBooks> allUserBooks =
      []; //Aqui se guardan todos los libros del usuario

  List<Book> finalBooks = [];

  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlGetReadingBooks + username);
  http.Response response = await http.get(myUri).timeout(Duration(seconds: 15));
  print(response.body);

  allUserBooks = (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((data) => UserBooks.fromJson(data))
      .toList();

  for (int i = 0; i < allUserBooks.length; i++) {
    Book aux = await crearLibro(allUserBooks[i].isbn);
    savedBooks.add(aux);
  }

  for (int i = 0; i < allUserBooks.length; i++) {
    String isbn = allUserBooks[i].isbn;
    Book aux = await crearLibro(isbn);
    //Solo se añade si coincide la busqueda
    if (aux.title.toLowerCase().contains(book.toLowerCase())) {
      finalBooks.add(aux);
    }
  }
  return finalBooks;
}

Future<List<Book>> getBooksDiscover() async {
  List<Book> allBooks = []; //Aqui se guardan todos los libros del usuario

  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlGetAllBooks);
  http.Response response = await http.get(myUri).timeout(Duration(seconds: 15));
  ;
  print("ESTO EEEEEES ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  print(response.body);

  allBooks = (json.decode(utf8.decode(response.bodyBytes)) as List)
      .map((data) => Book.fromJson(data))
      .toList();

  return allBooks;
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
void PostCollection(String collection, List<Book> books) async{
  //Simulación de creación de colección
  print("bookFacade-postcollection");
  print(collection);
  //update bakend
  String librosString = "";
  for (Book book in books) {
    librosString += book.isbn + ",";
  }
  librosString = librosString.substring(0, librosString.length-1);
  final toSend = {
    "titulo": collection,
    "libros": librosString,
  };
  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlColeccion + username);
  http.Response response = await http.put(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  print(jsonResponse);
  if (response.statusCode == 200) {
    //update cache
    collections[collection] = books;
  }
}

//Renombrar la coleccion "Oldcollection" del usuario "username" por
// "NewCollectionName
void RenameCollection( String OldCollectionName, String NewCollectionName) async{
  //update backend
  final toSend = {
    "oldTitulo": OldCollectionName,
    "newTitulo": NewCollectionName,
  };
  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlColeccion + "rename/" + username);
  http.Response response = await http.put(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  print(jsonResponse);
  if (response.statusCode == 200) {
    //update cache
    List<Book> collectionBooks = [];
    collectionBooks = collections[OldCollectionName];
    collections.remove(OldCollectionName);
    collections[NewCollectionName] = collectionBooks;
  }
}

//Eliminar la coleccion "collectionName" del usuario "username"
void DeleteCollection(String collectionName) async{
  //update backend
  final toSend = {
    "titulo": collectionName,
  };
  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();
  Uri myUri = Uri.parse(apiUrlColeccion + "delete/" + username);
  http.Response response = await http.put(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(utf8.decode(response.bodyBytes));
  print(jsonResponse);
  if (response.statusCode == 200) {
    //update cache
    collections.remove(collectionName);
  }
}

void deleteBookFromUser(String isbn) async {
  SessionManager s = new SessionManager();
  String nombreUsuario = await s.getNombreUsuario();

  print("Se  va a borrar el libro: " + isbn + " del usuario: " + nombreUsuario);
}

void addBookToUser(String isbn) async {
  SessionManager s = new SessionManager();
  String username = await s.getNombreUsuario();

  Uri myUri = Uri.parse(apiAddBookToUser + username + "/" + isbn);
  final toSend = {"currentOffset": "0", "leyendo": "false"};

  http.Response response = await http.post(myUri, body: toSend);
  print("ESTO EEEEEES ->>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>>");
  print(response.body);
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
