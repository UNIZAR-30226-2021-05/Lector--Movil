import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'user.dart';
import 'package:shared_preferences/shared_preferences.dart';

String apiUrlLogin = 'https://lectorbrainbook.herokuapp.com/rest-auth/login/';

String apiUrlRegister =
    'https://lectorbrainbook.herokuapp.com/rest-auth/registration/';

String apiUrlChangePass =
    "https://lectorbrainbook.herokuapp.com/rest-auth/password/change/";

String apiUrlGetUser = "https://lectorbrainbook.herokuapp.com/usuario/";

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
    sharedPreferences.setString("nombreUsuario", usuario.nombreUsuario);
    sharedPreferences.setString("email", usuario.email);
    sharedPreferences.setString("contrasenya", usuario.pass);

    return true;
  } else {
    return false;
  }
}

Future<bool> loginUsuario(String username, String pass) async {
  final toSend = {
    "username": username,
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
    sharedPreferences.setString("nombreUsuario", username);
    getAndStoreUserInfo();
    sharedPreferences.setString("contrasenya", pass);
    return true;
  } else {
    print('Usuario o contraseña incorrecto');
    return false;
  }
}

Future<bool> updatePass(String pass1, String pass2) async {
  final toSend = {
    "new_password1": pass1,
    "new_password2": pass2,
  };

  Uri myUri = Uri.parse(apiUrlChangePass);
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String key = sharedPreferences.getString("key");
  print("Voy a cambiar la contraseña de este token: " + key);
  print(pass1);
  print(pass2);
  http.Response response = await http.post(
    myUri,
    body: toSend,
    headers: {'Authorization': 'Token $key'},
  );
  // var jsonResponse = null;
  // jsonResponse = json.decode(response.body);
  // print(jsonResponse);
  //El codigo de respuesta para si hay usuario correcto o incorrecto, es 200 para OK y 400 para credenciales invalidas
  if (response.statusCode == 200) {
    return true;
  } else {
    return false;
  }
}

void getAndStoreUserInfo() async {
  SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
  String key = sharedPreferences.getString("key");
  String nombre = sharedPreferences.getString("nombreUsuario");
  apiUrlGetUser = apiUrlGetUser + nombre;
  Uri myUri = Uri.parse(apiUrlGetUser);

  http.Response response =
      await http.get(myUri, headers: {'Authorization': 'Token $key'});
  var jsonResponse = null;
  jsonResponse = json.decode(response.body);
  User user = User.fromJson(jsonResponse);
  //Aqui parece que hay un error
  sharedPreferences.setString("nombreUsuario", user.nombreUsuario);
  sharedPreferences.setString("email", user.email);
}
