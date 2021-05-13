import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libros/src/models/CircularBuffer.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

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
  //Variables de preferencias del usuario
  String colorBg = "Blanco";
  String colorLetra = "Negro";
  int tamanyoLetra = 12;
  String tipoLetra = "Arial";

  _BookPageState() {
    getUserPreferences();
  }

  String texto = "";

  int currentOffset = 0; //Offset actual
  int finOffset = 0;
  String pathPDF = "";

  CircularBuffer buffer;
  int numRebotes; //Número de "rebotes" al hacer un drag update horizontal
  bool drag; //Permiso para hacer drag horizontal
  int numPagina; //Número actual de página
  int pageCharacters = 900; //Número de caracteres por página

  @override
  void initState() {
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
              setState(() {
                if (drag)
                  buffer.leerDcha().then((String t) {
                    numPagina++;
                    texto = t;
                  });
                numRebotes++; //Recibido rebote
                drag = numRebotes < 1; //Actualizo permiso
              });
            } else if (details.delta.dx > sensitivity) {
              setState(() {
                if (drag) {
                  buffer.leerIzda().then((String t) {
                    texto = t;
                    if (numPagina > 1) numPagina--;
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
              SizedBox(height: 1),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  SizedBox(width: 1),
                  IconButton(
                      icon: Icon(Icons.arrow_back_ios),
                      onPressed: () {
                        Navigator.pop(context);
                      }), //Este es el boton para ir hacia atrás

                  Text(
                    data["book"].title,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        fontSize: 25),
                  ),
                  IconButton(
                      icon: Icon(Icons.bookmark),
                      onPressed:
                          () {}), //Este es el boton para añadir bookmarks
                  SizedBox(width: 1),
                ],
              ),
              SizedBox(height: 18),
              Center(
                child: SizedBox(
                  height: 610,
                  width: 350,
                  child: Text(
                    texto,
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.blue[800],
                        fontSize: 25),
                  ),
                ),
              ),
              Text(numPagina.toString()),
            ],
          ),
        ),
      ),
    );
  }

  void startBuffer() {
    var currentOffset = 0; //TODO: Obtener el actual offset backend
    buffer = new CircularBuffer("ljkl", currentOffset, pageCharacters);
  }

  getUserPreferences() async {
    SessionManager s = new SessionManager();
    String key = await s.getKey();
    String usuario = await s.getNombreUsuario();
    Uri myUri = Uri.parse(apiUrlGetPreferences + usuario);
    http.Response response = await http.get(
      myUri,
      headers: {'Authorization': 'Token $key'},
    );
    var jsonResponse = null;
    jsonResponse = json.decode(response.body);
    print(jsonResponse);
    setState(() {
      tamanyoLetra = jsonResponse["tamanoLetra"];
      tipoLetra = jsonResponse["tipoLetra"];
      colorBg = jsonResponse["colorBg"];
      colorLetra = jsonResponse["colorLetra"];
    });
  }
}
