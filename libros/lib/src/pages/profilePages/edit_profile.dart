import 'package:flutter/material.dart';
import 'package:libros/src/pages/profilePages/configuration_page.dart';
import 'package:libros/src/pages/profilePages/edit_email.dart';
import 'package:libros/src/pages/profilePages/edit_name.dart';
import 'package:libros/src/pages/profilePages/edit_photo.dart';
/*
  Esta pantalla muestra el perfil del usuario
  Está gestionada por el módulo HomePage
 */

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

//No incluir Scaffold (lo añade HomePage)
class _EditProfileState extends State<EditProfile> {
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
                          'Editar perfil',
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
                            width: 120.0,
                            height: 120.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                        'https://img.huffingtonpost.com/asset/5ead5c6e2500006912eb0beb.png?cache=VGVQqRsEJs&ops=1200_630')))),
                      ),
                      SizedBox(height: 20),
                      Text("Facundo Garcia Pimienta", textScaleFactor: 1.8),
                      SizedBox(height: 10),
                      Text("facundo@gmail.com", textScaleFactor: 1.3),
                      Padding(
                        padding: const EdgeInsets.only(top: 50.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditName()));
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Editar nombre',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditEmail()));
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Cambiar email',
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 15.0),
                        child: SizedBox(
                          width: 200,
                          child: RaisedButton(
                            onPressed: () {
                              Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                      builder: (context) => EditPhoto()));
                            },
                            elevation: 4,
                            textColor: Colors.white,
                            color: Colors.blue[900],
                            padding: const EdgeInsets.all(12.0),
                            child: Text(
                              'Cambiar foto de perfil',
                            ),
                          ),
                        ),
                      )
                    ],
                  ))
                ]))));
  }
}
