import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';

class BookDetailsPage extends StatefulWidget {
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  //Mapa para recibir argumentos
  Map data = {};

  @override
  Widget build(BuildContext context) {
    //Libro recibido
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
      elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
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

      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 30.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                height: 220,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      Container(
                          width: 150,
                          child: Image.network(data["book"].pathCover)),
                      SizedBox(width: 20.0),
                      Flexible(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: <Widget>[
                            Text(
                              data["book"].title,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                              style: TextStyle(
                                fontSize: 20.0,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            Text(
                              data["book"].author,
                              style: TextStyle(
                                fontSize: 17.0,
                                fontWeight: FontWeight.bold,
                                color: Colors.grey,
                              ),
                            ),
                            SizedBox(height: 10.0),
                            SizedBox(height: 5.0),
                          ],
                        ),
                      )
                    ]),
              ),
              SizedBox(height: 20.0),
              Text("Sinopsis"),
              Divider(
                height: 30,
                thickness: 2,
              ),
              Text(
                data["book"].synopsis,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color: Colors.grey[600],
                ),
                maxLines: 10,
              ),
              SizedBox(height: 30.0),
              Center(
                child: SizedBox(
                  width: 120,
                  child: ElevatedButton(
                  style: ButtonStyle(
                  backgroundColor:
                  MaterialStateProperty.all<Color>(Colors.blue),
                  ),
                  child: Text("Abrir libro"),
                  onPressed: () {
                  //TODO: LLAMAR A BACKEND UPDATE ESTADO LIBRO
                  //Se abre el libro, y además se actualiza el estado
                    Navigator.pushNamed(context, "book", arguments: {'book' :
                    data["book"]});
                    }
                    //addBookToUser(data["book"].isbn);
                  ),
                ),
              ),
                  ],
          ),
        ),
      ),
    );
  }

  void handleClick(String value) async{
    switch (value) {
      case 'Eliminar':
        print("handleCLIK");
        //Mensaje de confirmación de eliminación
        await delBookToUser(data["book"].isbn);
        setState(() {
          Navigator.pushReplacementNamed(context,'home',arguments:
          {'currentIndex': 1});
        });
        //TODO:LLAMAR A BACKEND PARA ELIMINAR LIBRO DE BIBLIOTECA DEL USUARIO
        break;
    }
  }

  dynamic anyadirConfirmacion() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('¿Seguro que desea añadir ' +
              data["book"].title +
              " a su biblioteca?"),
          actions: <Widget>[
            FlatButton(
              child: Text('Cancelar'),
              onPressed: () {
                Navigator.of(context).pop(); //cerrar confirmación
              },
            ),
            FlatButton(
              child: Text('Añadir',
                  style: TextStyle(
                    color: Colors.red,
                  )),
              onPressed: () {
                //Aqui hay que hablar con back para ver si se le pasa el titulo del libro o que otro paramaetro para que ellos hagan la busqueda
                addBookToUser(data['book'].isbn);
                //Mensaje ok
                final snackBar = SnackBar(
                    backgroundColor: Colors.green,
                    content: Text('¡Añadido correctamente!'));
                ScaffoldMessenger.of(context).showSnackBar(snackBar);
                Navigator.of(context).pop(); //cerrar confirmación
                Navigator.of(context).pop(); //volver a pantalla library_page
              },
            ),
          ],
        );
      },
    );
  }
}
