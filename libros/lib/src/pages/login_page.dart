import 'package:flutter/material.dart';
import 'package:crypt/crypt.dart';
import 'package:libros/src/models/userFacade.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String _email = '';
  String _pass = '';
  var _controllerEmail = TextEditingController();
  var _controllerContrasenya = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
          child: Container(
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.bottomCenter,
                end: Alignment.topCenter,
                colors: [Colors.blue, Colors.green])),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 150),
            Align(
              child: Image(
                image: AssetImage('assets/logo.png'),
                height: 120,
              ),
            ),
            SizedBox(height: 35),
            Text(
              'BrainBook',
              style: TextStyle(color: Colors.black, fontSize: 30.0),
            ),
            SizedBox(height: 20),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child: _ponerEmail(),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
              child: _ponerContrasenya(),
            ),
            SizedBox(height: 30),
            Padding(
              padding: const EdgeInsets.all(20.0),
              child: Align(
                alignment: Alignment.bottomLeft,
                child: Row(
                  children: [
                    SizedBox(
                      width: 140,
                      child: RaisedButton(
                        color: Colors.white,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_sharp),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 80),
                      child: SizedBox(
                        width: 140,
                        child: RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          onPressed: () {
                            print("Voy a hacer login");
                            final passFinal = Crypt.sha256(_pass);
                            print(_email);
                            print(passFinal);
                            loginUsuario(_email, passFinal.toString(), context,
                                _controllerEmail, _controllerContrasenya);
                          },
                          child: Text('Iniciar sesión'),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      )),
    );
  }

  Widget _ponerEmail() {
    return TextField(
      // autofocus: true,
      controller: _controllerEmail,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Correo electrónico',
        labelText: 'Email',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _email = valor;
        });
      },
    );
  }

  Widget _ponerContrasenya() {
    return TextField(
      // autofocus: true,
      controller: _controllerContrasenya,
      obscureText: true,
      keyboardType: TextInputType.visiblePassword,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Contraseña',
        labelText: 'Contraseña',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _pass = valor;
        });
      },
    );
  }
}
