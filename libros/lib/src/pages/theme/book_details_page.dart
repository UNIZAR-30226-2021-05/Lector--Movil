import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
class BookDetailsPage extends StatefulWidget {
  @override
  _BookDetailsPageState createState() => _BookDetailsPageState();
}

class _BookDetailsPageState extends State<BookDetailsPage> {
  @override
  Widget build(BuildContext context) {
    //Argumentos recibidos al invocar BookPage
    Map data = ModalRoute.of(context).settings.arguments;
    return Scaffold(
      appBar: AppBar(
        elevation: 0.0,
        actions: <Widget>[
          PopupMenuButton<String>(
            onSelected: handleClick,
            itemBuilder: (BuildContext context) {
              return {'Eliminar libro de la biblioteca'}.map((String opcion) {
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
              height:220,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: <Widget>[
                  Image.network(data["book"].pathCover),
                  SizedBox(width: 20.0),
                  Column(
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
                          color:Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      SizedBox(height: 5.0),
                      for(var i=0; i < data["book"].genres.length; i++)
                        Container(
                          padding: EdgeInsets.fromLTRB(20.0, 2.0, 20.0, 2.0),
                          decoration: BoxDecoration(
                            border: Border.all(
                              color: Colors.blue,
                            ),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                            child: Text (data["book"].genres[i]),
                        )
                     //Text( data["book"].genres.toString()),
                    ],
                  )
                ]
              ),
            ),
              SizedBox(height: 10.0),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                 /* TextButton(
                      onPressed: () {
                        //TODO: LLAMAR A BACKEND UPDATE ESTADO LIBRO
                      },
                      child: Text(
                          "Eliminar de mi biblioteca",
                        style: TextStyle(
                          color: Colors.red,
                        ),
                      ),
                  ),*/
                  Expanded(
                    child: ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all<Color>(Colors
                              .blue),
                        ),
                        child: Text("Leer libro"),
                        onPressed: () {
                          //TODO: LLAMAR A BACKEND UPDATE ESTADO LIBRO
                        },
                    ),
                  ),
                ],
              ),
              SizedBox(height: 30.0),
              Text("Sinopsis"),
              Divider(
                height: 30,
                thickness: 2,
              ),
              Text(data["book"].synopsis,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  color:Colors.grey[600],
                ),
                maxLines: 10,
              )
          ],
          ),
        ),
      ),
    );
  }
  void handleClick(String value) {
    switch (value) {
      case 'Eliminar libro de biblioteca':
        print('LOG: has pulsado eliminar libro!!');
        //TODO:LLAMAR A BACKEND PARA ELIMINAR LIBRO DE BIBLIOTECA DEL USUARIO
        break;
    }
  }
}
