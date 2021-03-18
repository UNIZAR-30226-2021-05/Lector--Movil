import 'dart:core';
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

void loginUsuario(String username, String pass) async {
  final toSend = {
    "username": username,
    "password": pass,
  };
  Uri myUri = Uri.parse(apiUrlLogin);
  http.Response response = await http.post(myUri, body: toSend);
  print('Response body: ${response.body}');
}
