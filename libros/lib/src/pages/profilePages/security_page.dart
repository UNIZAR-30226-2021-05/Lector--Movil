import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libros/src/pages/profilePages/change_password.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';

/*
  Esta pantalla muestra la configuracion del usuario
 */

class SecurityPage extends StatefulWidget {
  @override
  _SecurityPageState createState() => _SecurityPageState();
}

//No incluir Scaffold (lo añade HomePage)
class _SecurityPageState extends State<SecurityPage> {
  SessionManager session = new SessionManager();
  String _nombreUsuario = '';
  String _email = '';
  String _pathFoto = '';
  _SecurityPageState() {
    getUserInfo();
  }

  getUserInfo() async {
    session.getNombreUsuario().then((String result) {
      setState(() {
        _nombreUsuario = result;
      });
    });
    session.getEmail().then((String result) {
      setState(() {
        _email = result;
      });
    });
    session.getpathPhoto().then((String result) {
      setState(() {
        _pathFoto = result;
      });
    });
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
                          icon: new Icon(Icons.arrow_back_ios_rounded,
                              size: 40.0),
                          onPressed: () {
                            Navigator.pop(context);
                          },
                        ),
                        Text(
                          'Seguridad',
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
                  Center(
                      child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    // mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Padding(
                        padding: const EdgeInsets.only(top: 40.0),
                        child: Container(
                          width: 100.0,
                          height: 100.0,
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(100),
                            child: FadeInImage(
                                fit: BoxFit.cover,
                                placeholder:
                                    AssetImage("assets/defaultProfile.png"),
                                image: NetworkImage(_pathFoto)),
                          ),
                        ),
                      ),
                      SizedBox(height: 20),
                      Text(_nombreUsuario, textScaleFactor: 1.4),
                      SizedBox(height: 10),
                      Text(_email, textScaleFactor: 1.1),
                      SizedBox(height: 15),
                      Padding(
                        padding: const EdgeInsets.only(top: 90.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => ChangePassword()));
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Modificar contraseña',
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ]))));
  }
}
