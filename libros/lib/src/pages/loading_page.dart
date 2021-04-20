/*
  Muestra un gif de un spin de loading y comprueba si el usuario tiene
  una sesión activa en la aplicación.
 */
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:libros/src/models/userFacade.dart';
import 'package:libros/src/pages/first_page.dart';

class Loading extends StatefulWidget {
  @override
  _LoadingState createState() => _LoadingState();
}

class _LoadingState extends State<Loading> {

  checkLoginStatus() async {
    SharedPreferences sharedPreferences = await SharedPreferences.getInstance();
    if (sharedPreferences.getString("key") == null) {
      print("Te tengo que llevar al login que no estas logueado");
      Navigator.pushReplacementNamed(context, 'firstPage');
    } else {
      print("No bro, esta es tu key: " + sharedPreferences.getString("key"));
      Navigator.pushReplacementNamed(context, 'home');
      getAndStoreUserInfo();
    }
  }

  @override
  void initState() {
    super.initState();
    checkLoginStatus();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
          child: SpinKitSquareCircle(
            color: Colors.blue,
            size: 50.0,
          )
      ),
    );
  }
}
