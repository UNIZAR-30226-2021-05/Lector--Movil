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
          child:Text("profile_page"),
        );
  }
}
