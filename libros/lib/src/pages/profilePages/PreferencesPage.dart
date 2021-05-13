import 'package:flutter/material.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PreferencesPage extends StatefulWidget {
  PreferencesPage({Key key}) : super(key: key);

  @override
  _PreferencesPageState createState() => _PreferencesPageState();
}

class _PreferencesPageState extends State<PreferencesPage> {
  String colorBg = "Escoge un color";
  String colorLetra = "Escoge un color";
  int tamanyoLetra = 10;
  String tipoLetra = "Escoge una fuente";
  _PreferencesPageState() {
    getUserPreferences();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
          child: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 0.0),
              child: Column(children: <Widget>[
                Padding(
                  padding: const EdgeInsets.all(12.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      new IconButton(
                        icon:
                            new Icon(Icons.arrow_back_ios_rounded, size: 40.0),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                      ),
                      Text(
                        'Preferencias',
                        style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.2,
                  color: Colors.black38,
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color de fondo ",
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    Container(
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10)),
                      child: DropdownButton<String>(
                        hint: Text(colorBg),
                        items: <String>[
                          'Verde',
                          'Negro',
                          'Azul',
                          'Rojo',
                          'Naranja',
                          'Blanco'
                        ].map((String value) {
                          return new DropdownMenuItem<String>(
                            value: value,
                            child: new Text(value),
                          );
                        }).toList(),
                        onChanged: (_) {
                          setState(() {
                            colorBg = _;
                          });
                        },
                      ),
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Color de letra ",
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    DropdownButton<String>(
                      hint: Text(colorLetra),
                      items: <String>[
                        'Verde',
                        'Negro',
                        'Azul',
                        'Rojo',
                        'Naranja',
                        'Blanco'
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          colorLetra = _;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tamaño de letra ",
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    DropdownButton<int>(
                      hint: Text(tamanyoLetra.toString()),
                      items: <int>[10, 11, 12, 13, 14, 15].map((int value) {
                        return new DropdownMenuItem<int>(
                          value: value,
                          child: new Text(value.toString()),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          tamanyoLetra = _;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Tipo de letra ",
                      style: TextStyle(
                        fontSize: 25.0,
                      ),
                    ),
                    DropdownButton<String>(
                      hint: Text(tipoLetra),
                      items: <String>[
                        'Arial',
                        'Times',
                        'Calibri',
                      ].map((String value) {
                        return new DropdownMenuItem<String>(
                          value: value,
                          child: new Text(value),
                        );
                      }).toList(),
                      onChanged: (_) {
                        setState(() {
                          tipoLetra = _;
                        });
                      },
                    )
                  ],
                ),
                SizedBox(height: 40),
                SizedBox(
                  width: 200,
                  child: RaisedButton(
                    onPressed: () {
                      cambiarPreferenciasUsuario(colorBg, colorLetra,
                          tamanyoLetra.toString(), tipoLetra);
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => PreferencesPage()));
                    },
                    elevation: 4,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.all(Radius.circular(12.0))),
                    textColor: Colors.white,
                    color: Colors.green,
                    padding: const EdgeInsets.all(12.0),
                    child: Text(
                      'Cambiar preferencias',
                    ),
                  ),
                )
              ]))),
    );
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
