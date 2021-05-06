import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import '../components/bookCard.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

/*
  Esta pantalla muestra la lista de los libros que está leyendo el usuario
  Está gestionada por el módulo HomePage
 */
class ReadingPage extends StatefulWidget {
  @override
  _ReadingPageState createState() => _ReadingPageState();
}

class _ReadingPageState extends State<ReadingPage> {
  //List<Book> readingBooks = [];
  Future<List<Book>> readingBooks;


  @override
  void initState() {
    super.initState();
    //Actualizo los libros que está leyendo el usuario
    //TODO: Obtener el username de la sesion
    //readingBooks = GetBooksReading("Pepe");
    readingBooks = GetBooksReading();
    //TODO: CONECTAR CON GetBooksReading()cuando haya backend

  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text(
                      "Leyendo",
                      style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                      ),
                  ),
                  Divider(
                    height: 20.0,
                    thickness: 2,
                  ),
                  Expanded(
                    child: _buildReadingBooks(),
                  )

                ],
              ),
            ),
        );
  }

  Widget _buildReadingBooks() {
    return FutureBuilder<List<Book>>(
        future: readingBooks,
        builder: (context, snapshot) {
          if (snapshot.connectionState != ConnectionState.done) {
            // return: show loading widget
            return Center(
                child: SpinKitSquareCircle(
                  color: Colors.blue,
                  size: 50.0,
                )
            );
          }
          if (snapshot.hasError) {
            // return: show error widget
            return Text("Error al cargar lista");
          }
          List<Book> readingBooks = snapshot.data ?? [];
          return ListView.builder(
            itemCount: readingBooks.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return bookCard(readingBooks[index], "book", context);
            },
          );
        }
    );
  }
}
