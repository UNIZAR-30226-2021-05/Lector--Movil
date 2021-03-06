import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:libros/src/models/bookFacade.dart';

class BookDetailsDiscoverPage extends StatefulWidget {
  @override
  _BookDetailsDiscoverPage createState() => _BookDetailsDiscoverPage();
}

class _BookDetailsDiscoverPage extends State<BookDetailsDiscoverPage> {
  //Mapa para recibir argumentos
  Map data = {};

  @override
  Widget build(BuildContext context) {
    //Libro recibido
    data = ModalRoute.of(context).settings.arguments;

    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(30.0, 30.0, 10.0, 0.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              SizedBox(height: 20.0),
              Container(
                height: 220,
                child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(
                        height: 220,
                        width: 120,
                        child: Image.network(
                          data["book"].pathCover,
                          fit: BoxFit.fitHeight,
                        ),
                      ),
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
                  width: 200,
                  child: ElevatedButton(
                    style: ButtonStyle(
                      backgroundColor:
                          MaterialStateProperty.all<Color>(Colors.green),
                    ),
                    child: Text("Añadir libro a la biblioteca"),
                    onPressed: () {
                      anyadirConfirmacion();
                    },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
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
              },
            ),
          ],
        );
      },
    );
  }
}
