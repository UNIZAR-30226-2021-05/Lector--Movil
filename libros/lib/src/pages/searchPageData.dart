import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/components/bookCardMin.dart';
import 'package:libros/src/pages/mainPages/search_page.dart';
import 'package:libros/src/pages/searchedBookDiscover.dart';
import 'package:libros/src/pages/searchedBookLibrary.dart';
import 'package:material_floating_search_bar/material_floating_search_bar.dart';

/*
  Esta pantalla permite hacer búsquedas de libros al usuario
  Está gestionada por el módulo HomePage
 */

class SearchPageData extends StatefulWidget {
  String book = '';
  SearchPageData({Key key, @required this.book}) : super(key: key);

  @override
  _SearchPageDataState createState() => _SearchPageDataState(libro: book);
}

//No incluir Scaffold (lo añade HomePage)
class _SearchPageDataState extends State<SearchPageData> {
  String libro = '';
  List<Book> listaAMostrar = [];

  _SearchPageDataState({@required this.libro});

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
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => SearchPage()));
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
                    barraBusqueda(editingController, libro),
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
                          InkWell(
                            child: Text(
                              "Ver todo >>",
                              style: TextStyle(fontSize: 15),
                            ),
                            onTap: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) =>
                                          SearchedBookLibrary(book: libro)));
                            },
                          ),
                        ],
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(
                        height: 200, child: listarLibrosBiblioteca(libro)),
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 30.0, left: 8.0, right: 8.0),
                      child: Container(
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Descubre",
                              style: TextStyle(fontSize: 25),
                            ),
                            InkWell(
                              child: Text(
                                "Ver todo >>",
                                style: TextStyle(fontSize: 15),
                              ),
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            SearchedBookDiscover(book: libro)));
                              },
                            ),
                            //LISTAR TODOS AQUELLOS LIBROS
                            //
                          ],
                        ),
                        //SE LISTAN LOS LIBROS DE LA BUSQUEDA EN ROW
                      ),
                    ),
                    SizedBox(
                      height: 15,
                    ),
                    Container(height: 200, child: listarLibrosDescubre(libro)),
                  ]))),
    );
  }

  Widget barraBusqueda(TextEditingController ed, String libro) {
    return TextField(
      onSubmitted: (datos) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchPageData(book: datos)));
      },
      controller: ed,
      decoration: InputDecoration(
          hintText: "$libro",
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    );
  }

  Widget listarLibrosBiblioteca(String libro) {
    List<Book> listaAMostrar = getBooksSearched("Pepe", libro);

    if (listaAMostrar.isNotEmpty) {
      return Row(children: [
        Expanded(
          child: ListView.builder(
            itemCount: 3,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return bookCardMin(listaAMostrar[index], "bookDetails", context);
            },
          ),
        ),
      ]);
    } else {
      return Center(child: Text('No hay busquedas que coincidan :('));
    }
  }

  Widget listarLibrosDescubre(String libro) {
    getBooksAux();
    int count = 0;
    if (listaAMostrar.isNotEmpty) {
      if (listaAMostrar.length >= 3) {
        count = 3;
      } else if (listaAMostrar.length == 2) {
        count = 2;
      } else {
        count = 1;
      }
      return Row(children: [
        Expanded(
          child: ListView.builder(
            itemCount: count,
            scrollDirection: Axis.horizontal,
            itemBuilder: (context, index) {
              return bookCardMin(listaAMostrar[index], "bookDetails", context);
            },
          ),
        ),
      ]);
    } else {
      return Center(child: Text('No hay busquedas que coincidan :('));
    }
  }

  getBooksAux() {
    getBooksDiscover(libro).then((List<Book> result) {
      setState(() {
        listaAMostrar = result;
      });
    });
  }
}
