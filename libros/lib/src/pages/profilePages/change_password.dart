import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:libros/src/models/userFacade.dart';

/*
  Esta pantalla muestra la configuracion del usuario
 */
String passAnterior = '';

class ChangePassword extends StatefulWidget {
  SharedPreferences _sp;

  @override
  _ChangePasswordState createState() => _ChangePasswordState();
  ChangePassword() {
    _obtenerPass();
  }

  _obtenerPass() async {
    _sp = await SharedPreferences.getInstance();
    passAnterior = _sp.getString("contrasenya");
  }
}

//No incluir Scaffold (lo añade HomePage)
class _ChangePasswordState extends State<ChangePassword> {
  String _passActual = '';
  String _passNueva1 = '';
  String _passNueva2 = '';
  var _controllerActual = TextEditingController();
  var _controllerNueva1 = TextEditingController();
  var _controllerNueva2 = TextEditingController();

  SessionManager session = new SessionManager();
  String _nombreUsuario = '';
  String _email = '';
  _ChangePasswordState() {
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
  }

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
                          'Editar contraseña',
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
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                        'https://img.huffingtonpost.com/asset/5ead5c6e2500006912eb0beb.png?cache=VGVQqRsEJs&ops=1200_630')))),
                      ),
                      SizedBox(height: 20),
                      Text(_nombreUsuario, textScaleFactor: 1.4),
                      SizedBox(height: 10),
                      Text(_email, textScaleFactor: 1.1),
                      SizedBox(height: 15),
                      _crearCamposDeTexto()
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
            controller: _controllerActual,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'Contraseña',
              labelText: 'Contraseña actual',
              suffixIcon: Icon(Icons.lock),
            ),
            onChanged: (valor) {
              setState(() {
                _passActual = valor;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        TextField(
          // autofocus: true,
          controller: _controllerNueva1,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'Contraseña',
            labelText: 'Contraseña Nueva',
            suffixIcon: Icon(Icons.lock),
          ),
          onChanged: (valor) {
            setState(() {
              _passNueva1 = valor;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          // autofocus: true,
          controller: _controllerNueva2,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'Confirmar contraseña',
            labelText: 'Confirmar contraseña nueva',
            suffixIcon: Icon(Icons.lock),
          ),
          onChanged: (valor) {
            setState(() {
              _passNueva2 = valor;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () async {
                if (passAnterior == _passActual) {
                  _cambiarContrasenya(_passNueva1, _passNueva2);
                } else {
                  _mostrarMensajeDeErrorContrasenya();
                }
              },
              elevation: 4,
              textColor: Colors.white,
              color: Colors.green[600],
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Confirmar',
              ),
            ),
          ),
        )
      ],
    );
  }

  _mostrarMensajeDeErrorContrasenya() {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('La contraseña actual es incorrecta'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                _controllerActual.clear();
                _controllerNueva1.clear();
                _controllerNueva2.clear();
              },
            ),
          ],
        );
      },
    );
  }

  _cambiarContrasenya(String pass1, String pass2) async {
    bool cambioOk = await updatePass(pass1, pass2);
    if (cambioOk) {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('La contraseña ha sido modificada'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  SharedPreferences sp = await SharedPreferences.getInstance();
                  sp.setString("contrasenya", pass2);
                  _controllerActual.clear();
                  _controllerNueva1.clear();
                  _controllerNueva2.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
                'La contraseña no ha sido modificada. Recuerda que no debe ser parecida al nombre de usuario, deben coincidir y tener más de 8 letras.'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () async {
                  _controllerActual.clear();
                  _controllerNueva1.clear();
                  _controllerNueva2.clear();
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    }
  }
}
