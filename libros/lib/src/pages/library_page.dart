import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child:Text("library_page"),
      );
  }
}
