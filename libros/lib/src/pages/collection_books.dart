import 'package:flutter/material.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/pages/components/bookCard.dart';

class CollectionBooks extends StatefulWidget {
  @override
  _CollectionBooksState createState() => _CollectionBooksState();
}

class _CollectionBooksState extends State<CollectionBooks> {
  //Datos pasados como argumentos a la página
  Map data = {};
  List<Book> collectionBooks = []; //Libros de una collección del usuario


  @override
  Widget build(BuildContext context) {
    //Título de colección recibido desde library_page
    data = ModalRoute
        .of(context)
        .settings
        .arguments;

    print("collection_books-build");
    print(data['collectionName']);
    collectionBooks = GetCollectionBooks("Pepe", data['collectionName']);
    print(collectionBooks.length);

    return Scaffold(
        appBar: AppBar(
          title: Text(data['collectionName']),
          elevation: 0.0,
        ),
        body:Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 20.0),
          child: Expanded(
            child: ListView.builder(
              itemCount: collectionBooks.length,
              physics: BouncingScrollPhysics(),
              itemBuilder: (context, index) {
                return  bookCard(collectionBooks[index], 'bookDetails',
                    context);
              },
            ),
          ),
        )
    );
  }
}
