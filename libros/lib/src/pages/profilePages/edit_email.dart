import 'dart:ui';
import 'package:cool_alert/cool_alert.dart';

import 'package:flutter/material.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
/*
  Esta pantalla muestra la configuracion del usuario
 */

class EditEmail extends StatefulWidget {
  @override
  _EditEmailState createState() => _EditEmailState();
}

//No incluir Scaffold (lo añade HomePage)
class _EditEmailState extends State<EditEmail> {
  String _emailAntiguo = '';
  String _emailNuevo = '';
  SessionManager session = new SessionManager();
  String _nombreUsuario = '';
  String _emailMostrar = '';
  String _pathFoto = "";
  _EditEmailState() {
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
        _emailMostrar = result;
      });
    });
    session.getpathPhoto().then((String result) {
      setState(() {
        _pathFoto = result;
      });
    });
  }

  var _controllerEmailAntiguo = TextEditingController();
  var _controllerEmailNuevo = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                          'Editar email',
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
                      Text(_emailMostrar, textScaleFactor: 1.1),
                      SizedBox(height: 55),
                      _crearCamposDeTexto(),
                    ],
                  ))
                ]))));
  }

  Widget _crearCamposDeTexto() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextField(
            // autofocus: true,
            controller: _controllerEmailAntiguo,
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'Email antiguo',
              suffixIcon: Icon(Icons.mail),
            ),
            onChanged: (valor) {
              setState(() {
                _emailAntiguo = valor;
              });
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextField(
            // autofocus: true,
            controller: _controllerEmailNuevo,
            obscureText: false,
            keyboardType: TextInputType.emailAddress,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'Nuevo email',
              suffixIcon: Icon(Icons.mail),
            ),
            onChanged: (valor) {
              setState(() {
                _emailNuevo = valor;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () async {
                bool ok = await comprobarEmailAntiguo();
                if (ok) {
                  SessionManager s = new SessionManager();
                  String pathPhoto = await s.getpathPhoto();
                  String username = await s.getNombreUsuario();
                  updateUserInfo(_emailNuevo, pathPhoto, username);
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.success,
                    text: 'Tu correo se ha cambiado con exito',
                    autoCloseDuration: Duration(seconds: 2),
                  );
                } else {
                  CoolAlert.show(
                    context: context,
                    type: CoolAlertType.error,
                    text: 'Oops! El email antiguo no coincide',
                    autoCloseDuration: Duration(seconds: 2),
                  );
                }
              },
              elevation: 4,
              textColor: Colors.white,
              color: Colors.green[600],
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Confirmar cambios',
              ),
            ),
          ),
        )
      ],
    );
  }

  Future<bool> comprobarEmailAntiguo() async {
    SessionManager s = new SessionManager();
    String emailDeAhora = await s.getEmail();
    if (_emailAntiguo == emailDeAhora) {
      return true;
    } else {
      return false;
    }
  }
}
