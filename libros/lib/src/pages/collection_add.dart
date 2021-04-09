import 'package:flutter/material.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/book.dart';


class CollectionAdd extends StatefulWidget {
  @override
  _CollectionAddState createState() => _CollectionAddState();
}

class _CollectionAddState extends State<CollectionAdd> {
  //Datos pasados como argumentos a la página
  Map data = {};
  List<Book> savedBooks = []; //Libros pertenecientes al usuario
  List<Book> selectedBooks = []; //Libros para añadir a la colección

  @override
  void initState() {
    super.initState();
    //Actualizo los libros guardados por el usuario
    //TODO: Obtener el username de la sesion
    savedBooks = GetBooksSaved("Pepe");
  }
  @override
  Widget build(BuildContext context) {
    //Título de colección recibido desde library_page
    data = ModalRoute
        .of(context)
        .settings
        .arguments;

    return Scaffold(
      appBar: AppBar(
        title: Text("Añadir libros a la colección"),
        elevation: 0.0,
      ),
      body:Padding(
        padding: const EdgeInsets.fromLTRB(20.0, 20.0, 30.0, 20.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                itemCount: savedBooks.length,
                physics: BouncingScrollPhysics(),
                itemBuilder: (context, index) {
                  return  _BookSelectionCard(savedBooks[index]);
                },
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(selectedBooks.length.toString() + " libros seleccionados"),
                _CreateCollection(),
              ],
            ),
          ],
        ),
      )
    );
  }

  Widget _BookSelectionCard(Book book) {
    return Column(
      children: [
        Container(
          margin: EdgeInsets.fromLTRB(30.0, 20.0, 30.0, 0.0),
          height: 70,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      SizedBox(width: 30.0),
                      Text(
                        book.title,
                        style: TextStyle(
                          fontSize: 20.0,
                        ),
                      ),
                      Text(
                      book.author,
                      style: TextStyle(
                      fontSize: 15.0,
                      ),
                      ),
                    ],
                  ),
                  _buttonSelectBook(book),
                ],
              ),
              Divider(
                thickness: 2,
              )
            ],
          ),
        ),
      ],
    );
  }

  Widget _buttonSelectBook(Book book) {
    final alreadySelected = selectedBooks.contains(book);
    return IconButton(
      icon: alreadySelected
          ? Icon(Icons.check)
          : Icon(Icons.add_circle),
      onPressed: () {
        setState(() {
          if (alreadySelected) {
            selectedBooks.remove(book);
          } else {
            selectedBooks.add(book);
          }
        });
      }
    );
  }

  Widget _CreateCollection() {
    return OutlineButton (
      splashColor:Colors.grey,
      highlightedBorderColor: Colors.black,
      onPressed: () {
        SnackBar snackBar;
        if (selectedBooks.length == 0) {
           snackBar = SnackBar(
              backgroundColor: Colors.orange,
              content: Text('Selecciona al menos un libro')
          );
        } else {
          print("collection_add-createcollection");
          print(data["collectionName"]);
          PostCollection("paco", data["collectionName"], selectedBooks);
          Navigator.pushReplacementNamed(context, 'library');
          snackBar = SnackBar(
              backgroundColor: Colors.blue,
              content: Text('¡Nueva colección creada!')
          );
        }
        ScaffoldMessenger.of(context).showSnackBar(snackBar);
      },
      highlightElevation: 0,
      borderSide: BorderSide(
          color: Colors.grey),
      child:
      Text(
        'Crear',
        style: TextStyle(
          fontSize: 17,
          color:Colors.black,
        ),
      ),

    );
  }
}
