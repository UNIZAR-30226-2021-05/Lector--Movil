import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libros/src/models/bookFacade.dart';

//TODO: DISEÑAR LA GESTIÓN DEL BUFFER DE TEXTO
//TODO: IMPLEMENTAR BUFFER CON COLA CIRCULAR
//TODO: GESTIONAR LOS OFFSETS(CURRENTOFFSET, INITBUFFEROFFSET).
class BookPage extends StatefulWidget {
  final String path;
  const BookPage({Key key, this.path}) : super(key: key);

  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  Map data = {};
  bool loaded = false;

  String texto = "";

  int currentOffset; //Offset actual
  String pathPDF = "";

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    pedirTexto();
    if (loaded) {
      return Scaffold(
        body: Center(
          child: Text(texto),
        ),
      );
    } else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }
  }

  void pedirTexto() {
    String path = data["book"].url;
    getText(path, 0, 500, 0, 0).then((String result) {
      setState(() {
        texto = result;
      });
    });
    loaded = true;
  }
}
