import 'package:flutter/material.dart';
import 'components/bookCard.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';
/*
  Esta pantalla muestra los libros que posee el usuario
  Está gestionada por el módulo HomePage
 */


class LibraryPage extends StatefulWidget {
  @override
  Library_State createState() => Library_State();
}
//No incluir Scaffold (lo añade HomePage)
class Library_State extends State<LibraryPage> {
  List<Book> savedBooks = [];

  @override
  void initState() {
    super.initState();
    //Actualizo los libros guardados por el usuario
    //TODO: Obtener el username de la sesion
    savedBooks = SavedBooksList("Pepe");

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
              "Biblioteca",
              style: TextStyle(
                fontSize: 30.0,
                letterSpacing: 2.0,
              ),
            ),
            Divider(
              height: 30,
              thickness: 2,
            ),
            SizedBox(height: 10.0),
            Container(
              height: 90,
              child: _colecciones(),
            ),
            SizedBox(height: 20.0),
            Text(
              "Tus libros guardados",
              style: TextStyle(
                fontSize: 23.0,
              ),
            ),
            Expanded(
              child: ListView.builder(
                itemCount: savedBooks.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return  bookCard(savedBooks[index],"bookDetails", context);
                },
              ),
            )

          ],
        ),
      ),
    );
  }

  //Botón de colecciones
  Widget _colecciones() {
    return OutlineButton (
        splashColor:Colors.grey,
        highlightedBorderColor: Colors.grey,
        onPressed: () {
          //TODO:LLAMAR A PAGINA DE COLECCIONES
        },
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        highlightElevation: 0,
        borderSide: BorderSide(color: Colors.grey),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Text(
              'Tus colecciones',
              style: TextStyle(
                fontSize: 17,
                color:Colors.black,
              ),
            ),
            SizedBox(width:80.0),
            Icon(Icons.arrow_forward_ios_sharp),
          ],

        )
    );
  }

}
