import 'package:flutter/material.dart';
import 'package:libros/src/pages/searchPageData.dart';

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
    var editingController;
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 0.0),
              child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      "Busqueda",
                      style: TextStyle(
                        fontSize: 25.0,
                        letterSpacing: 1.0,
                      ),
                    ),
                    Divider(
                      height: 20.0,
                      thickness: 2,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    barraBusqueda(editingController),
                  ]))),
    );
  }

  Widget barraBusqueda(TextEditingController ed) {
    return TextField(
      onSubmitted: (datos) {
        Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => SearchPageData(book: datos)));
      },
      controller: ed,
      decoration: InputDecoration(
          hintText: "Buscar ...",
          suffixIcon: Icon(Icons.search),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(25.0)))),
    );
  }
}
