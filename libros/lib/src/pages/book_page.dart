import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/models/CircularBuffer.dart';


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


  CircularBuffer buffer;
  int numRebotes; //Número de "rebotes" al hacer un drag update horizontal
  bool drag;//Permiso para hacer drag horizontal
  int numPagina; //Número actual de página
  int pageCharacters = 900; //Número de caracteres por página


  @override
  void initState(){
    super.initState();
    startBuffer();
    numPagina = (buffer.GetCurrentOffset() / pageCharacters).floor() + 1;
    buffer.leerDcha().then((String t) {
      setState(() {
        texto = t;
      });
    });
  }

  @override
  Widget build(BuildContext context) {

    data = ModalRoute.of(context).settings.arguments;
    //pedirTexto();
    //if (loaded) {
      return Scaffold(
        body: SafeArea(
          child: GestureDetector(
            onHorizontalDragStart: (details) {
              setState(() {
                print("dragStart");
                numRebotes = 0; //Reseteo rebotes
                drag = true; //Permiso para hacer drag
              });
            },
            onHorizontalDragUpdate: (details) {
              int sensitivity = 8;
              if (details.delta.dx < -sensitivity) {
                //print("Estoy desplazandome a la derachaaaaaaaa");
                setState(() {
                   if(drag)
                     buffer.leerDcha().then((String t) {
                        numPagina++;
                        texto = t;
                    });
                    numRebotes++; //Recibido rebote
                    drag = numRebotes < 1; //Actualizo permiso
                });
              } else if (details.delta.dx > sensitivity) {
                //if (currentOffset >= 900)
                  setState(()  {
                    if(drag) {
                       buffer.leerIzda().then((String t) {
                          texto = t;
                          if(numPagina >1) numPagina--;
                      });
                      numRebotes++; //Recibido rebote
                      drag = numRebotes < 1; //Actualizo permiso
                      }
                  });
              }
            },
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Center(
                  child: SizedBox(
                    height: 610,
                    width: 350,
                    child: Text(texto),
                  ),
                ),
                SizedBox(height:20.0),
                Text(numPagina.toString()),
              ],
            ),
          ),
        ),
      );
    /*} else {
      return Scaffold(
        body: Center(
          child: CircularProgressIndicator(),
        ),
      );
    }*/
  }

  void startBuffer() {
    var currentOffset = 0; //TODO: Obtener el actual offset backend
    buffer = new CircularBuffer("ljkl",
        currentOffset, pageCharacters);
  }

}
