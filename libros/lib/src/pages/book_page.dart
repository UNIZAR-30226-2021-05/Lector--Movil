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
  int _stars = 0;
  String tituloBookmark = "";
  String cuerpoBookmark = "";

  //Variables de preferencias del usuario
  int colorBg;
  int colorLetra;
  int tamanyoLetra;
  String tipoLetra;
  bool loaded = false;
  TextEditingController _textFieldController = TextEditingController();
  TextEditingController _textFieldController2 = TextEditingController();

  String texto = "";

  int currentOffset = 0; //Offset actual
  int finOffset = 0;
  String pathPDF = "";

  CircularBuffer buffer;
  int numRebotes; //Número de "rebotes" al hacer un drag update horizontal
  bool drag; //Permiso para hacer drag horizontal
  int numPagina; //Número actual de página
  int pageCharacters = 850; //Nº caracteres/pagina para tamaño letra 14

  @override
  void initState() {
    super.initState();
    startBuffer();
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (loaded) {
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
            child: ListView(
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
                        onPressed: () {
                          showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return AlertDialog(
                                    title: Center(
                                        child: Text("Añadir un bookmark")),
                                    content: Column(
                                      children: [
                                        TextField(
                                          onChanged: (value) {
                                            tituloBookmark = value;
                                          },
                                          decoration: InputDecoration(
                                              //border: OutlineInputBorder(),
                                              hintText: 'Titulo'),
                                        ),
                                        SizedBox(height: 30),
                                        TextField(
                                          onChanged: (value) {
                                            cuerpoBookmark = value;
                                          },
                                          decoration: InputDecoration(
                                              //border: OutlineInputBorder(),
                                              hintText: 'Cuerpo'),
                                        ),
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancelar'),
                                        onPressed: Navigator.of(context).pop,
                                      ),
                                      FlatButton(
                                        child: Text('Añadir'),
                                        onPressed: () {
                                          //AÑADIR EL BOOKMARK
                                          Navigator.of(context).pop(_stars);
                                        },
                                      )
                                    ]);
                              });
                        }), //Este es el boton para añadir bookmarks
                    SizedBox(width: 1),
                    IconButton(
                        icon: Icon(Icons.rate_review),
                        onPressed: () {
                          AlertDialog alert = AlertDialog(
                            title: Center(
                              child: Text('Evalua este libro'),
                            ),
                            content: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: <Widget>[
                                _buildStar(1),
                                _buildStar(2),
                                _buildStar(3),
                                _buildStar(4),
                                _buildStar(5),
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('Cancelar'),
                                onPressed: Navigator.of(context).pop,
                              ),
                              FlatButton(
                                child: Text('OK'),
                                onPressed: () {
                                  Navigator.of(context).pop(_stars);
                                },
                              )
                            ],
                          );
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return alert;
                            },
                          );
                        }), //Este es el boton para añadir bookmarks
                    SizedBox(width: 1),
                  ],
                ),
                SizedBox(height: 18),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                        //color: Color(colorBg),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: SizedBox(
                          height: 610,
                          width: 350,
                          child: Text(
                            texto,
                            style: TextStyle(
                                color: Color(colorLetra), fontSize: 15.0),
                          )),
                    ),
                  ),
                ),
                SizedBox(height: 4),
                Center(child: Text(numPagina.toString())),
              ],
            ),
          ),
        ),
      );
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void startBuffer() async {
    await getUserPreferences();
    var currentOffset = 0; //TODO: Obtener el actual offset backend
    buffer = new CircularBuffer(
        "ljkl", currentOffset, getPageCharacters(tamanyoLetra));
    numPagina = (buffer.GetCurrentOffset() / pageCharacters).floor() + 1;
    buffer.leerDcha().then((String t) {
      setState(() {
        texto = t;
      });
    });
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
      tamanyoLetra = 14; //jsonResponse["tamanoLetra"];
      tipoLetra = jsonResponse["tipoLetra"];
      if (jsonResponse["colorBg"] == "Blanco") {
        colorBg = Colors.white.value;
      } else if (jsonResponse["colorBg"] == "Negro") {
        colorBg = Colors.black.value;
      } else if (jsonResponse["colorBg"] == "Verde") {
        colorBg = Colors.green.value;
      } else if (jsonResponse["colorBg"] == "Azul") {
        colorBg = Colors.blue.value;
      } else if (jsonResponse["colorBg"] == "Rojo") {
        colorBg = Colors.red.value;
      } else {
        colorBg = Colors.orange.value;
      }

      if (jsonResponse["colorLetra"] == "Blanco") {
        colorLetra = Colors.white.value;
      } else if (jsonResponse["colorLetra"] == "Negro") {
        colorLetra = Colors.black.value;
      } else if (jsonResponse["colorLetra"] == "Verde") {
        colorLetra = Colors.green.value;
      } else if (jsonResponse["colorLetra"] == "Azul") {
        colorLetra = Colors.blue.value;
      } else if (jsonResponse["colorLetra"] == "Rojo") {
        colorLetra = Colors.red.value;
      } else {
        colorLetra = Colors.orange.value;
      }
      loaded = true;
    });
  }

  int getPageCharacters(int tamanyoLetra) {
    print("getPageCharacters");
    int result = 900;
    switch (tamanyoLetra) {
      case 15:
        {
          result = 600;
        }
        break;
      case 14:
        {
          result = 600;
        }
        break;
      case 13:
        {
          result = 600;
        }
        break;
      case 12:
        {
          result = 600;
        }
        break;
      case 11:
        {
          result = 650;
        }
        break;
      case 10:
        {
          result = 700;
        }
        break;
      default:
        {
          print("ERROR getPageCharacters() " + tamanyoLetra.toString());
        }
    }
    return result;
  }

  Widget _buildStar(int starCount) {
    return InkWell(
      child: Icon(
        Icons.star,
        color: _stars >= starCount ? Colors.yellow[700] : Colors.grey,
      ),
      onTap: () {
        setState(() {
          _stars = starCount;
        });
      },
    );
  }
}
