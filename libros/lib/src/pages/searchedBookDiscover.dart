import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/components/bookCard.dart';
import 'package:libros/src/pages/components/bookCardMin.dart';
import 'package:libros/src/pages/mainPages/search_page.dart';

/*
  Esta pantalla permite hacer búsquedas de libros al usuario
  Está gestionada por el módulo HomePage
 */

class SearchedBookDiscover extends StatefulWidget {
  String book = '';
  SearchedBookDiscover({Key key, @required this.book}) : super(key: key);

  @override
  _SearchedBookDiscoverState createState() =>
      _SearchedBookDiscoverState(libro: book);
}

//No incluir Scaffold (lo añade HomePage)
class _SearchedBookDiscoverState extends State<SearchedBookDiscover> {
  String libro = '';
  List<Book> listaAMostrar = [];
  bool loadedDiscover = false;
  _SearchedBookDiscoverState({@required this.libro}) {
    getBooksAux();
  }

  getBooksAux() {
    getBooksDiscover().then((List<Book> result) {
      setState(() {
        listaAMostrar = result;
        loadedDiscover = true;
      });
    });
  }

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
                            "Descubre",
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
                    listarLibrosDiscover(),
                    SizedBox(
                      height: 15,
                    ),
                  ]))),
    );
  }

  Widget listarLibrosDiscover() {
    if (loadedDiscover) {
      if (listaAMostrar.isNotEmpty) {
        return Expanded(
          child: ListView.builder(
            itemCount: listaAMostrar.length,
            scrollDirection: Axis.vertical,
            itemBuilder: (context, index) {
              return bookCard(
                  listaAMostrar[index], "bookDetailsDiscoverPage", context);
            },
          ),
        );
      } else {
        return Center(child: Text('No hay busquedas que coincidan :('));
      }
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
