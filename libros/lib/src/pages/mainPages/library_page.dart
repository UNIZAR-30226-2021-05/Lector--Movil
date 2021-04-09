import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/bookCard.dart';
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
  List<String> collections = [];
  final List<Tab> myTabs = <Tab>[
    Tab(text: 'Libros'),
    Tab(text: 'Colecciones'),
  ];

  @override
  void initState() {
    super.initState();
    //Actualizo los libros guardados por el usuario
    //TODO: Obtener el username de la sesion
    savedBooks = GetBooksSaved("Pepe");
    collections = GetCollections("Pepe");

  }


  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: myTabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: Padding(
            padding: const EdgeInsets.fromLTRB(0.0, 10.0, 30.0, 0.0),
            child: Text(
              "Mis libros",
              style: TextStyle(
                fontSize: 25.0,
                fontWeight: FontWeight.normal,
              ),
            ),
          ),
          bottom: TabBar(
            indicatorColor: Colors.blue,
            tabs: myTabs
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 30.0, 0.0),
          child: TabBarView(
            children: [
              ListView.builder(
                itemCount: savedBooks.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return  bookCard(savedBooks[index],"bookDetails", context);
                },
              ),
              _colecctions(),
            ],
          )
        ),
      ),
    );
  }
  Widget _colecctions() {
    if(collections.isEmpty) {
      return _EmptyCollectionMessage();
    } else {
      return Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: collections.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return  GestureDetector(
                onTap: () {
                  //Navegar a collection_books, pasando el título de la
                  //colección seleccionada como argumento
                  print("library_page-_collections");
                  print(collections[index]);
                  Navigator.pushNamed(context,'collectionBooks',arguments:
                  {'collectionName': collections[index]});
                },
                child: Container(
                  margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
                  height: 70,
                  child: Card(
                      color: Colors.blue,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            SizedBox(width: 30.0),
                            Text(
                              collections[index],
                              style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                              ),
                            ),
                            PopupMenuButton<String>(
                              onSelected: handleClickCollectionCard,
                              icon: Icon(
                                Icons.menu_sharp,
                                color: Colors.white,
                              ),
                              itemBuilder: (BuildContext context) {
                                return {'Eliminar'}.map((String opcion) {
                                  return PopupMenuItem<String>(
                                    value: opcion,
                                    child: Text(opcion),
                                  );
                                }).toList();
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  ),
                ),
              );
            },
          ),
          SizedBox(height: 20.0),
          _buttonAddCollection(),
        ],
      );
    }
  }

  //Eliminar colección
  void handleClickCollectionCard(String value) {
    switch (value) {
      case 'Eliminar':
        //TODO:ELIMINAR COLECCIÓN DEL USUARIO
        final snackBar = SnackBar(
            backgroundColor: Colors.blue,
            content: Text('¡Eliminado correctamente!')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
    }
  }
  Widget _EmptyCollectionMessage() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget> [
        Flexible(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                "Gestiona tus libros",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: 10.0),
              Text(
                "Organiza tus libros creando y poniendo nombre a tus propias "
                    "colecciones.",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              Text(
                "Por ejemplo, podrías reunir todos los libros de "
                    "uno de tus géneros favoritos dentro de una colección.",
                overflow: TextOverflow.ellipsis,
                maxLines: 3,
              ),
              SizedBox(height: 10.0),
              _buttonAddCollection(),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonAddCollection() {
    return OutlineButton (
        splashColor:Colors.grey,
        highlightedBorderColor: Colors.black,
        onPressed: () {
          //TODO:LLAMAR A PESTAÑA DE CREACIÓN DE COLECCIONES
          _AlertAddCollection();
        },
        highlightElevation: 0,
        borderSide: BorderSide(
            color: Colors.grey),
        child:
          Text(
            'Crear una colección',
            style: TextStyle(
              fontSize: 17,
              color:Colors.black,
            ),
          ),

    );
  }

  dynamic _AlertAddCollection() {
    String _collectionName = "";
    String _hintText = "Nombre de la colección";
    return showDialog(
      context: context,
        builder: (BuildContext context) {
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            title: Text('Crear una nueva colección'),
            content: TextField(
                  onChanged: (value) {
                    setState(() {
                      _collectionName = value;
                    });
                  },
                  decoration: InputDecoration(hintText: _hintText),
                ),
            actions: <Widget>[
              FlatButton(
                child: Text('Cancelar'),
                onPressed: () {
                  Navigator.of(context).pop(); //cerrar confirmación
                },
              ),
              TextButton(
                child: Text(
                  'Siguiente',
                ),
                onPressed: _collectionName.isEmpty ? null : () {
                  //TODO: LLAMAR A BACKEND UPDATE ESTADO LIBRO
                  //LLamo a página collection_add pasándole el título de la
                  // colección
                    Navigator.pushNamed(context, 'collectionAdd', arguments:
                    {'collectionName': _collectionName});
                },
              ),
            ],
          );
          });
        }
    );
  }
}
