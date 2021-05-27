import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:libros/src/models/Bookmarks.dart';
import 'package:libros/src/models/CircularBuffer.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/theme/all_bookmarks.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

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
  String asunto = "Fragmento obtenido del libro ";
  String destino = "";

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
                          updateUserBookState(data["book"].isbn,
                              buffer.getCurrentOffset(), true);
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
                        onPressed: () async {
                          List<Bookmark> bm = [];
                          bm = await getBookmarks(data["book"].isbn);
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
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(top: 12.0),
                                          child: ElevatedButton(
                                            child: Text('Mis bookmarks'),
                                            onPressed: () {
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) =>
                                                          AllBookmarks(
                                                              data["book"]
                                                                  .isbn)));
                                            },
                                          ),
                                        )
                                      ],
                                    ),
                                    actions: <Widget>[
                                      FlatButton(
                                        child: Text('Cancelar'),
                                        onPressed: Navigator.of(context).pop,
                                      ),
                                      FlatButton(
                                        child: Text('Añadir'),
                                        onPressed: () async {
                                          String isbn = data["book"].isbn;
                                          int ofset = 0;
                                          await getCurrentOffset(isbn)
                                              .then((int result) {
                                            // setState(() {
                                            ofset = result;
                                            //});
                                          });

                                          postBookmark(isbn, tituloBookmark,
                                              cuerpoBookmark, ofset.toString());

                                          Navigator.of(context).pop();
                                        },
                                      )
                                    ]);
                              });
                        }), //Este es el boton para añadir bookmarks
                    SizedBox(width: 1),
                    IconButton(
                        icon: Icon(Icons.send),
                        onPressed: () {
                          AlertDialog alert = AlertDialog(
                            title: Center(
                              child: Text('Envía tu fragmento'),
                            ),
                            content: Column(
                              children: [
                                Text(
                                    "Atención! Usted va a ser redirigido a su plataforma de "
                                    "correo electrónico. Asegurese de copiar el fragmento de texto que quiere enviar."),
                                Padding(
                                  padding: const EdgeInsets.only(top: 20.0),
                                  child: TextField(
                                    keyboardType: TextInputType.emailAddress,
                                    onChanged: (value) {
                                      setState(() {
                                        destino = value;
                                      });
                                    },
                                    decoration: InputDecoration(
                                        //border: OutlineInputBorder(),
                                        hintText: 'Destino...'),
                                  ),
                                )
                              ],
                            ),
                            actions: <Widget>[
                              FlatButton(
                                child: Text('IR'),
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  final Uri _emailLaunchUri = Uri(
                                      scheme: 'mailto',
                                      path: destino,
                                      queryParameters: {
                                        'subject': asunto +
                                            data["book"].title +
                                            " desde BrainBook"
                                      });
                                  launch(_emailLaunchUri.toString());
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
                        }),
                    IconButton(
                        icon: Icon(Icons.rate_review),
                        onPressed: () {
                          AlertDialog alert = AlertDialog(
                            title: Center(
                              child: Text('Evalúa este libro'),
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
                                child: Text('EVALUAR'),
                                onPressed: () {
                                  Navigator.of(context).pop(_stars);
                                  enviarValoracion(data["book"].isbn, _stars);
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
                        color: Color(colorBg),
                        //color: Colors.white,
                        borderRadius: BorderRadius.circular(12)),
                    child: Center(
                      child: SizedBox(
                          height: 610,
                          width: 350,
                          child: SelectableText(
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
    await getCurrentOffset(data["book"].isbn).then((int result) {
      // setState(() {
      currentOffset = result;
      //});
    });
    buffer = new CircularBuffer(
        data["book"].url, currentOffset, getPageCharacters(tamanyoLetra));
    numPagina = (buffer.getCurrentOffset() / pageCharacters).floor() + 1;
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
      } else if (jsonResponse["colorBg"] == "white") {
        colorBg = Colors.white.value;
      } else if (jsonResponse["colorBg"] == "black") {
        colorBg = Colors.black.value;
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
      } else if (jsonResponse["colorLetra"] == "white") {
        colorLetra = Colors.white.value;
      } else if (jsonResponse["colorLetra"] == "black") {
        colorLetra = Colors.black.value;
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
