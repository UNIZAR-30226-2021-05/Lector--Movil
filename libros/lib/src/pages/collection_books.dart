import 'package:flutter/material.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/pages/components/bookCard.dart';

/*
  Interfaz. Lista los libros pertenecientes a una colección.
 */
class CollectionBooks extends StatefulWidget {
  @override
  _CollectionBooksState createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooks> {
  Map data = {}; //Nombre de la colección. Recibido como argumento.
  List<Book> collectionBooks = []; //Libros de una colección del usuario

  @override
  Widget build(BuildContext context) {
    //Título de colección recibido desde library_page
    data = ModalRoute.of(context).settings.arguments;

    collectionBooks = GetCollectionBooks("Pepe", data['collectionName']);

    return Scaffold(
        appBar: AppBar(
          title: Text(data['collectionName']),
          elevation: 0.0,
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 20.0),
          child: Expanded(
            child: ListView.builder(
              itemCount: collectionBooks.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return bookCard(collectionBooks[index], 'bookDetails', context);
              },
            ),
          ),
        ));
  }
}
