import 'package:flutter/material.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';

/*
  Interfaz. Lista todos los libros guardados por el usuario.
  Permite que el usuario pueda hacer una selección de libros y los incluya en
  una colección.
 */

class CollectionAdd extends StatefulWidget {
  @override
  _CollectionAddState createState() => _CollectionAddState();
}

class _CollectionAddState extends State<CollectionAdd> {
  Map data = {}; //Nombre de la colección. Recibido como argumento.
  List<Book> savedBooks = []; //Libros guardados por el usuario
  List<Book> selectedBooks = []; //Libros seleccionados para ser añadidos.
  bool loaded = false;

  _CollectionAddState() {
    pedirLibros();
  }

  pedirLibros() {
    //TODO: Llamar a getBooksSaved no con pepe, si no con el current user
    getBooksSaved("Pepe").then((List<Book> result) {
      setState(() {
        savedBooks = List.from(result);
        loaded = true;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (loaded) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Añadir libros a la colección"),
            elevation: 0.0,
          ),
          body: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 20.0),
            child: Column(
              children: [
                Expanded(
                  child: ListView.builder(
                    itemCount: savedBooks.length,
                    physics: BouncingScrollPhysics(),
                    itemBuilder: (context, index) {
                      return _BookSelectionCard(savedBooks[index]);
                    },
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(selectedBooks.length.toString() +
                        " libros seleccionados"),
                    _CreateCollection(),
                  ],
                ),
              ],
            ),
          ));
    } else {
      return Scaffold(
          body: Container(child: Center(child: CircularProgressIndicator())));
    }
  }

  //Representación de un libro con el título y el autor.
  Widget _BookSelectionCard(Book book) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          height: 70,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 30.0),
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                        book.author,
                        style: TextStyle(
                          fontSize: 15.0,
                        ),
                      ),
                    ],
                  ),
                  _buttonSelectBook(book),
                ],
              ),
              Divider(
                thickness: 2,
              )
            ],
          ),
        ),
      ],
    );
  }

  //Muestra un icono pulsable y añade o elimina el libro "book" de la selección
  //de libros del usuario.
  Widget _buttonSelectBook(Book book) {
    final alreadySelected = selectedBooks.contains(book);
    return IconButton(
        icon: alreadySelected ? Icon(Icons.check) : Icon(Icons.add_circle),
        onPressed: () {
          setState(() {
            if (alreadySelected) {
              selectedBooks.remove(book);
            } else {
              selectedBooks.add(book);
            }
          });
        });
  }

  //Si el usuario no ha seleccionado ningún libro, se muestra un warning al
  // usuario
  //Si el usuario ha seleccionado al menos un libro, se crea una nueva
  // colección
  Widget _CreateCollection() {
    return OutlineButton(
      splashColor: Colors.grey,
      highlightedBorderColor: Colors.black,
      onPressed: () {
        SnackBar snackBar;
        if (selectedBooks.length == 0) {
          //Caso no ha seleccionado ningún libro
          snackBar = SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Selecciona al menos un libro'));
        } else {
          PostCollection("paco", data["collectionName"], selectedBooks);
          Navigator.pushReplacementNamed(context, 'library',
              arguments: {'tabIndex': 1});
          snackBar = SnackBar(
              backgroundColor: Colors.blue,
              content: Text('¡Nueva colección creada!'));
        }
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      highlightElevation: 0,
      borderSide: BorderSide(color: Colors.grey),
      child: Text(
        'Crear',
        style: TextStyle(
          fontSize: 17,
          color: Colors.black,
        ),
      ),
    );
  }
}
