import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../components/bookCard.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';
/*
  Interfaz. Muestra libros guardados y colecciones del usuario.
  Gestionada por el Widget PageView del módulo HomePage
 */


class LibraryPage extends StatefulWidget {
  @override
  Library_State createState() => Library_State();
}

class Library_State extends State<LibraryPage> {

  List<Book> _savedBooks = []; //Libros guardados por el usuario
  List<String> _collections = []; //Colecciones del usuario
  String _selectedCollectionName = ""; //Nombre colección seleccionada
  int tabIndex = 0; //Por defecto el tabBar muestra los libros (índice 0)
  Map data = {}; //Índice del tabBar especificado como argumento


  final List<Tab> tabs = <Tab>[
    Tab(text: 'Libros'),
    Tab(text: 'Colecciones'),
  ];

  @override
  void initState() {
    super.initState();
    //Peticiónes a backend
    //TODO: Obtener el username de la sesion
    _savedBooks = GetBooksSaved("Pepe");
    _collections = GetCollections("Pepe");
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute
        .of(context)
        .settings
        .arguments;

    if (data != null && data.containsKey('tabIndex')) {
      //Caso especifico el índice del tab que quiero mostrar
      tabIndex = data['tabIndex'];
      data.remove('tabIndex');
    }

    return DefaultTabController(
      length: tabs.length,
      initialIndex: tabIndex,
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
            tabs: tabs
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.fromLTRB(20.0, 0.0, 30.0, 0.0),
          child: TabBarView(
            children: [
              _buildSavedBooks(),
              _builColections(),
            ],
          )
        ),
      ),
    );
  }

  //Muesta la lista de libros guardados por el usuario
  Widget _buildSavedBooks() {
    return ListView.builder(
      itemCount: _savedBooks.length,
      physics: BouncingScrollPhysics(),
      itemBuilder: (context, index) {
        return  bookCard(_savedBooks[index],"bookDetails", context);
      },
    );
  }

  // Si el usuario no tiene colecciones muestra un mensaje informativo
  // Si el usuario tiene colecciones muestra la lista de colecciones del usuario
  Widget _builColections() {
    if(_collections.isEmpty) {
      //Caso usuario no tiene colecciones
      return _EmptyCollectionMessage();
    } else {
      return Column(
        children: [
          ListView.builder(
            scrollDirection: Axis.vertical,
            shrinkWrap: true,
            itemCount: _collections.length,
            physics: BouncingScrollPhysics(),
            itemBuilder: (context, index) {
              return  GestureDetector(
                onTap: () {
                  //Mostrar libros de la colección llamada _collections[index]
                  //Se pasa el nombre de la colección como argumento
                  Navigator.pushNamed(context,'collectionBooks',arguments:
                  {'collectionName': _collections[index]});
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
                              _collections[index],
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
                                _selectedCollectionName = _collections[index];
                                return {'Renombrar','Eliminar'}.map((String
                                opcion) {
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

  //Eliminar colección del usuario
  void handleClickCollectionCard(String value) {
    switch (value) {
      case 'Renombrar':
        _AlertRenameCollection(_selectedCollectionName);
        break;
      case 'Eliminar':
        //TODO:ELIMINAR COLECCIÓN DEL USUARIO
        setState(() {
          DeleteCollection("paco", _selectedCollectionName);
          //Actualizo las colecciones de la caché
          _collections = GetCollections("Pepe");
          Navigator.pushReplacementNamed(context,'library',
              arguments: {'tabIndex': 1});
        });
        final snackBar = SnackBar(
            backgroundColor: Colors.blue,
            content: Text('¡Eliminado correctamente!')
        );
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
        break;
    }
  }

  //Mensaje informativo sobre las colecciones
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

  //Botón para crear una nueva colección
  Widget _buttonAddCollection() {
    return OutlineButton (
        splashColor:Colors.grey,
        highlightedBorderColor: Colors.black,
        onPressed: () {
          //Muestra un alert para insertar el nombre de la nueva colección
          _AlertAddCollectionName();
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

  //Permite ingresar al usuario el nombre de la nueva colección
  //Si el título es vacío impide al usuario continuar con el proceso.
  //Si el título no es vacío, muestra los libros que puede seleccionar.
  dynamic _AlertAddCollectionName() {
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
                    //Mostrar libros que puede seleccionar el usuario
                    //Le paso el título de la nueva colección como argumento
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

  dynamic _AlertRenameCollection(String oldName) {
    String _newCollectionName = "";
    return showDialog(
        context: context,
        builder: (BuildContext context) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: Text('Cambiar el nombre de la colección'),
              content: TextFormField(
                onChanged: (value) {
                  setState(() {
                    _newCollectionName = value;
                  });
                },
                initialValue: oldName,
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
                    'Hecho',
                  ),
                  onPressed: _newCollectionName.isEmpty ? null : () {
                    //Mostrar libros que puede seleccionar el usuario
                    //Le paso el título de la nueva colección como argumento
                    setState(() {
                      RenameCollection("Pepe", oldName, _newCollectionName);
                      //Actualizo las colecciones de la caché
                      _collections = GetCollections("Pepe");
                      Navigator.pushReplacementNamed(context,'library',
                          arguments: {'tabIndex': 1});
                    });
                  },
                ),
              ],
            );
          });
        }
    );
  }
}
