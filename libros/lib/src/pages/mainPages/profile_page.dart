import 'package:flutter/material.dart';
import 'package:libros/src/pages/profilePages/PreferencesPage.dart';
import 'package:libros/src/pages/profilePages/configuration_page.dart';
import 'package:libros/src/pages/profilePages/edit_profile.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';

/*
  Esta pantalla muestra el perfil del usuario
  Está gestionada por el módulo HomePage
 */

class ProfilePage extends StatefulWidget {
  @override
  _ProfilePageState createState() => _ProfilePageState();
}

//No incluir Scaffold (lo añade HomePage)
class _ProfilePageState extends State<ProfilePage> {
  SessionManager session = new SessionManager();
  String _nombreUsuario = '';
  String _email = '';
  String _pathFoto = '';
  _ProfilePageState() {
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
      body: SingleChildScrollView(
        child: SafeArea(
            child: Padding(
                padding: const EdgeInsets.fromLTRB(20.0, 30.0, 30.0, 0.0),
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Text(
                        'Perfil',
                        style: TextStyle(
                          fontSize: 30.0,
                          letterSpacing: 2.0,
                        ),
                      ),
                      Divider(
                        height: 30,
                        thickness: 2,
                      ),
                      SizedBox(height: 50.0),
                      Center(
                          child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Container(
                            width: 190.0,
                            height: 190.0,
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(100),
                              child: FadeInImage(
                                  fit: BoxFit.cover,
                                  placeholder:
                                      AssetImage("assets/defaultProfile.png"),
                                  image: NetworkImage(_pathFoto)),
                            ),
                          ),
                          SizedBox(height: 20),
                          Text(_nombreUsuario, textScaleFactor: 1.8),
                          SizedBox(height: 10),
                          Text(_email, textScaleFactor: 1.3),
                          SizedBox(height: 50),
                          SizedBox(
                            width: 200,
                            child: RaisedButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfile()));
                                },
                                shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.all(
                                        Radius.circular(12.0))),
                                elevation: 4,
                                textColor: Colors.white,
                                color: Colors.blue[900],
                                padding: const EdgeInsets.all(12.0),
                                child: Text(
                                  'Editar perfil',
                                )),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: 200,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            ConfigurationPage()));
                              },
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              textColor: Colors.white,
                              color: Colors.blue[900],
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Configuracion de la cuenta',
                              ),
                            ),
                          ),
                          SizedBox(height: 15),
                          SizedBox(
                            width: 200,
                            child: RaisedButton(
                              onPressed: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) =>
                                            PreferencesPage()));
                              },
                              elevation: 4,
                              shape: RoundedRectangleBorder(
                                  borderRadius:
                                      BorderRadius.all(Radius.circular(12.0))),
                              textColor: Colors.white,
                              color: Colors.blue[900],
                              padding: const EdgeInsets.all(12.0),
                              child: Text(
                                'Preferencias',
                              ),
                            ),
                          )
                        ],
                      ))
                    ]))),
      ),
    );
  }
}
