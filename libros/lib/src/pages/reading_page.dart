import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/library_page.dart';
import 'package:libros/src/pages/profile_page.dart';
import 'package:libros/src/pages/search_page.dart';
/*
  Esta pantalla muestra la lista de los libros que está leyendo el usuario
  Está gestionada por el módulo HomePage
 */
class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  List<Book> readingBooks = [];

  @override
  void initState() {
    super.initState();
    //Actualizo los libros que está leyendo el usuario
    //TODO: Obtener el username de la sesion
    readingBooks = ReadingBooksList("Pepe");

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Leyendo",
                      style: TextStyle(
                        fontSize: 30.0,
                        letterSpacing: 2.0,
                      ),
                  ),
                  Divider(
                    height: 30,
                    thickness: 2,
                  ),
                  Expanded(
                    child: ListView.builder(
                      itemCount: readingBooks.length,
                      physics: BouncingScrollPhysics(),
                      //shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return  _bookCard(readingBooks[index]);
                      },
                    ),
                  )

                ],
              ),
            ),
        );
  }


  //Widget que encapsula los datos de un libro
  //TODO: Hacer las card pulsables
  Widget _bookCard(Book book) {
    return Container(
      height:150,
      child: Card(
        child:Row(
          children: <Widget>[
           Padding(
             padding: EdgeInsets.all(4.0),
             child: Image.network(book.pathCover,
             ),
           ),
           SizedBox(width: 10),
           Text(book.title),
          ],
        )
      ),
    );
  }



}
