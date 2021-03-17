import 'package:flutter/material.dart';
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
  @override
  Widget build(BuildContext context) {
    return SafeArea(
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
                          decoration: new BoxDecoration(
                              shape: BoxShape.circle,
                              image: new DecorationImage(
                                  fit: BoxFit.fill,
                                  image: new NetworkImage(
                                      'https://internationalpadel.com/wp-content/plugins/all-in-one-seo-pack/images/default-user-image.png')))),
                      SizedBox(height: 20),
                      Text("Facundo Garcia Pimienta", textScaleFactor: 1.8),
                      SizedBox(height: 10),
                      Text("facundo@gmail.com", textScaleFactor: 1.3),
                      SizedBox(height: 50),
                      SizedBox(
                        width: 200,
                        child: RaisedButton(
                            onPressed: () {},
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
                          onPressed: () {},
                          elevation: 4,
                          textColor: Colors.white,
                          color: Colors.blue[900],
                          padding: const EdgeInsets.all(12.0),
                          child: Text(
                            'Configuracion de la cuenta',
                          ),
                        ),
                      )
                    ],
                  ))
                ])));
  }
}
