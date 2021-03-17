import 'package:flutter/material.dart';
/*
  Esta pantalla permite hacer búsquedas de libros al usuario
  Está gestionada por el módulo HomePage
 */

class SearchPage extends StatefulWidget {
  @override
  _SearchPageState createState() => _SearchPageState();
}

//No incluir Scaffold (lo añade HomePage)
class _SearchPageState extends State<SearchPage> {
  @override
  Widget build(BuildContext context) {
        return SafeArea(
          child:Text("search_page"),
        );
  }
}
