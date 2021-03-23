import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:libros/src/pages/home_page.dart';
import 'package:libros/src/pages/login_page.dart';
import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiUrlLogin = 'http://lectorbrainbook.herokuapp.com/rest-auth/login/';

String apiUrlRegister =
    'http://lectorbrainbook.herokuapp.com/rest-auth/registration/';

Future<bool> registrarUsuario(User usuario, BuildContext context) async {
  SharedPreferences sp;
  final toSend = {
    "username": usuario.nombreUsuario,
    "email": usuario.email,
    "password1": usuario.pass,
    "password2": usuario.pass
  };
  Uri myUri = Uri.parse(apiUrlRegister);
  http.Response response = await http.post(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  print("Esto es el response: " + response.body);
  print("Esto es el json response");
  print(jsonResponse);
  print(response.statusCode);

  print("Esto era el json response");
  if (response.statusCode == 201) {
    print(jsonResponse['key']);
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    sharedPreferences.setString("key", jsonResponse['key']);
    return true;
  } else {
    return false;
   /* return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
              'Vaya! Parece que ya tenemos un usuario registrado con las mismas credenciales'),
          actions: <Widget>[
            FlatButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );*/
  }
}

Future<bool> loginUsuario(String emailOrUsername, String pass) async {
  String campo = emailOrUsername.contains('@') ? 'email' : 'username';
  final toSend = {
    campo : emailOrUsername,
    "password": pass,
  };

  Uri myUri = Uri.parse(apiUrlLogin);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  http.Response response = await http.post(myUri, body: toSend);
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  print(jsonResponse);

  //El codigo de respuesta para si hay usuario correcto o incorrecto, es 200 para OK y 400 para credenciales invalidas
  if (response.statusCode == 200) {
    print(jsonResponse['key']);
    sharedPreferences.setString("key", jsonResponse['key']);
    //El nombre de usuario hay que pedirlo al backend por si el usuario
    //se ha logeado con el email
    //sharedPreferences.setString("nombreUsuario", username);
    // sharedPreferences.setString("email", email);
    sharedPreferences.setString("contrasenya", pass);
    return true;
  } else {
    print('Usuario o contraseña incorrecto');
    return false;
  }
}
