import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/profilePages/security_page.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../login_page.dart';
import '../registration_page.dart';

/*
  Esta pantalla muestra la configuracion del usuario
 */

class ConfigurationPage extends StatefulWidget {
  @override
  _ConfigurationPageState createState() => _ConfigurationPageState();
}

//No incluir Scaffold (lo añade HomePage)
class _ConfigurationPageState extends State<ConfigurationPage> {
  SharedPreferences sharedPreferences;
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
                        'Configuración',
                        style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ),
                Divider(
                  thickness: 1.7,
                  color: Colors.black38,
                ),
                SizedBox(
                  height: 40,
                ),
                _seguridad(),
                Divider(),
                _informacion(),
                Divider(),
                _ayuda(),
                _cerrarSesion(),
              ]))),
    );
  }

  Widget _seguridad() {
    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () {
          Navigator.push(
              context, MaterialPageRoute(builder: (context) => SecurityPage()));
        },
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.lock, size: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Seguridad',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _informacion() {
    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.info, size: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Información',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _ayuda() {
    return SizedBox(
      height: 100,
      child: InkWell(
        onTap: () {},
        child: Row(
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: Icon(Icons.question_answer, size: 40),
            ),
            Padding(
              padding: const EdgeInsets.only(left: 30.0),
              child: Align(
                alignment: Alignment.centerLeft,
                child: Text(
                  'Ayuda',
                  style: TextStyle(fontSize: 20),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _cerrarSesion() {
    return Padding(
      padding: const EdgeInsets.all(20.0),
      child: SizedBox(
        width: 200,
        height: 50,
        child: RaisedButton(
          color: Colors.red,
          shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.all(Radius.circular(12.0))),
          onPressed: () async {
            sharedPreferences = await SharedPreferences.getInstance();
            sharedPreferences.clear();
            sharedPreferences.commit();
            Navigator.of(context).pushAndRemoveUntil(
                MaterialPageRoute(
                    builder: (BuildContext context) => FirstPage()),
                (Route<dynamic> route) => false);
          },
          child: Text(
            'Cerrar sesión',
            style: TextStyle(color: Colors.white, fontSize: 18),
          ),
        ),
      ),
    );
  }
}
