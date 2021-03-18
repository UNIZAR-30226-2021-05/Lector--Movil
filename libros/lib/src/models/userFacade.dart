import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'user.dart';

String apiUrlLogin = 'http://lectorbrainbook.herokuapp.com/rest-auth/login/';

String apiUrlRegister =
    'http://lectorbrainbook.herokuapp.com/rest-auth/registration/';

void registrarUsuario(User usuario) async {
  final toSend = {
    "username": usuario.nombreUsuario,
    "email": usuario.email,
    "password1": usuario.pass,
    "password2": usuario.pass
  };
  Uri myUri = Uri.parse(apiUrlRegister);
  http.Response response = await http.post(myUri, body: toSend);
  print('Response body: ${response.body}');
}

void loginUsuario(
    String username,
    String pass,
    BuildContext context,
    TextEditingController controlEmail,
    TextEditingController controlContra) async {
  final toSend = {
    "username": username,
    "password": pass,
  };

  Uri myUri = Uri.parse(apiUrlLogin);
  http.Response response = await http.post(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  if (response.statusCode == 200) {
    jsonResponse = json.decode(response.body);
    if (jsonResponse != null) {
      print(jsonResponse['key']);
    }
  } else {
    print('Usuario o contraseña incorrecto');
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Email o contraseña incorrecto'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
                controlContra.clear();
                controlEmail.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
