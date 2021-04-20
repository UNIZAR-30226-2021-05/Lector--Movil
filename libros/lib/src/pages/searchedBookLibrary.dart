import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/components/bookCard.dart';

/*
  Esta pantalla permite hacer búsquedas de libros al usuario
  Está gestionada por el módulo HomePage
 */

class SearchedBookLibrary extends StatefulWidget {
  String book = '';
  SearchedBookLibrary({Key key, @required this.book}) : super(key: key);

  @override
  _SearchedBookLibraryState createState() =>
      _SearchedBookLibraryState(libro: book);
}

//No incluir Scaffold (lo añade HomePage)
class _SearchedBookLibraryState extends State<SearchedBookLibrary> {
  String libro = '';
  _SearchedBookLibraryState({@required this.libro});

  @override
  Widget build(BuildContext context) {
    var editingController;
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        IconButton(
                          icon: Icon(Icons.arrow_back_ios),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          "Busqueda",
                          style: TextStyle(
                            fontSize: 25.0,
                            letterSpacing: 1.0,
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 20.0,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 8.0, right: 8.0),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text(
                            "En tu biblioteca",
                            style: TextStyle(fontSize: 25),
                          ),
                        ],
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      thickness: 1.0,
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    listarLibrosBiblioteca(libro),
                    SizedBox(
                      height: 15,
                    ),
                  ]))),
    );
  }

  Widget listarLibrosBiblioteca(String libro) {
    List<Book> listaAMostrar = getBooksSearched("Pepe", libro);

    if (listaAMostrar.isNotEmpty) {
      return Expanded(
        child: ListView.builder(
          itemCount: listaAMostrar.length,
          scrollDirection: Axis.vertical,
          itemBuilder: (context, index) {
            return bookCard(listaAMostrar[index], "bookDetails", context);
          },
        ),
      );
    } else {
      return Center(child: Text('No hay busquedas que coincidan :('));
    }
  }
}
