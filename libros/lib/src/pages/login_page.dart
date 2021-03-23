import 'package:flutter/material.dart';
// import 'package:crypt/crypt.dart';
import 'package:libros/src/models/userFacade.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _loginKey = GlobalKey<FormState>();
  var _controllerEmailOrUsername = TextEditingController();
  var _controllerContrasenya = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: Container(
          width: MediaQuery.of(context).size.width,
          height: MediaQuery.of(context).size.height,
          /*decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      colors: [Colors.blue, Colors.green])),*/
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            reverse:true,
            child: Padding(
              padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 50.0),
                child: Form(
                  key: _loginKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
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
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 20),
                      _ponerEmailOrUsername(),
                      SizedBox(height: 15),
                      _ponerContrasenya(),
                      SizedBox(height: 80),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                          SizedBox(
                            width: 140,
                          child: RaisedButton(
                          color: Colors.green,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          onPressed: () async{
                            print("Voy a hacer login");
                            if(_loginKey.currentState.validate()) {
                              //Caso formulario correcto
                              print(_controllerEmailOrUsername);
                              print(_controllerContrasenya);
                              //Comprobación login correcto en backend
                              bool backendOk = await loginUsuario
                                (_controllerEmailOrUsername.text,
                                  _controllerContrasenya.text);
                              if(backendOk) {
                                //Caso login correcto en backend
                                print("Te mando al homepage");
                                Navigator.pushReplacementNamed(context,'home');
                              } else {
                                _errorLoginBackend();
                              }
                            }

                          },
                          child: Text('Iniciar sesión'),
                          ),
                        ),
                      ],
                      ),
                  ],
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  //Campo email o nombre de usuario
   Widget _ponerEmailOrUsername() {
    return TextFormField(
        controller: _controllerEmailOrUsername,
        decoration: InputDecoration(
          hintText: 'Email o nombre de usuario',
        ),
        validator: (value){
          //Caso campo vacío
          if (value.isEmpty) {
            return 'Campo obligatorio';
          }
          //Caso se introduce email pero no es válido
          RegExp emailPattern = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
              r".[a-zA-Z]+");
          if(value.contains('@') && !emailPattern.hasMatch(value)){
            return 'Email no válido';
          }
          return null;
        }
    );
  }
  //Campo "Contraseña"
   Widget _ponerContrasenya() {
    return TextFormField(
      controller: _controllerContrasenya,
      decoration: InputDecoration(
        hintText: 'Contraseña',
      ),
      validator: (value){
        //Caso campo vacío
        if (value.isEmpty) {
          return 'Campo obligatorio';
        }
        return null;
      },
      obscureText: true,
    );
  }

   Future<dynamic> _errorLoginBackend() {
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
                _controllerContrasenya.clear();
                _controllerEmailOrUsername.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
