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

  int currentOffset = 0; //Offset actual
  int finOffset = 0;
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
        body: GestureDetector(
          onHorizontalDragUpdate: (details) {
            int sensitivity = 8;
            if (details.delta.dx < -sensitivity) {
              print("Estoy desplazandome a la derachaaaaaaaa");
              setState(() {
                currentOffset = 900;
                finOffset = finOffset + 900;
                texto = mostrarTexto(texto, currentOffset, finOffset);
              });
            } else if (details.delta.dx > sensitivity) {
              if (currentOffset >= 900)
                setState(() {
                  currentOffset -= 900;
                  finOffset = finOffset - 900;
                  texto = mostrarTexto(texto, currentOffset, finOffset);
                });
            }
          },
          child: Center(
            child: SizedBox(
              height: 610,
              width: 350,
              child: Text(texto),
            ),
          ),
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

  String mostrarTexto(String text, int inicio, int fin) {
    return text.substring(inicio, fin);
  }

  void pedirTexto() {
    currentOffset = 0;
    finOffset = 900;
    String path = data["book"].url;
    getText(path, 0, 15000, 0, 0).then((String result) {
      setState(() {
        texto = result;
      });
    });
    loaded = true;
  }
}
