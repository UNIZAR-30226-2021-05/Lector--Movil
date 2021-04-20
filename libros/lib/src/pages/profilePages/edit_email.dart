import 'dart:ui';

import 'package:flutter/material.dart';
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
  String _email = '';
  SessionManager session = new SessionManager();
  String _nombreUsuario = '';
  String _emailMostrar = '';
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
  }

  var _controllerEmail = TextEditingController();
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
            controller: _controllerEmail,
            obscureText: false,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'Email',
              suffixIcon: Icon(Icons.mail),
            ),
            onChanged: (valor) {
              setState(() {
                _email = valor;
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
              onPressed: () {},
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
}
