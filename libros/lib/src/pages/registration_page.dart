import 'package:flutter/material.dart';
import 'package:crypt/crypt.dart';
import 'package:flutter/painting.dart';
import 'package:libros/src/models/user.dart';
import 'package:libros/src/models/userFacade.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _registerKey = GlobalKey<FormState>();
  var _controllerUsername = TextEditingController();
  var _controllerEmail = TextEditingController();
  var _controllerPass1 = TextEditingController();
  var _controllerPass2 = TextEditingController();

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
                        begin: Alignment.topRight,
                        end: Alignment.bottomLeft,
                        colors: [Colors.blue, Colors.red])),*/
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/bg.jpg"),
              fit: BoxFit.fill,
            ),
          ),
          child: SingleChildScrollView(
            reverse: true,
            child: Padding(
              //Relleno necesario para hacer scroll
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              child: Padding(
                padding: const EdgeInsets.fromLTRB(50.0, 0.0, 50.0, 50.0),
                child: Form(
                  key: _registerKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      SizedBox(height: 150),
                      Text(
                        'BrainBook',
                        style: TextStyle(color: Colors.black, fontSize: 30.0),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 50),
                      _crearNombreUsuario(),
                      SizedBox(height: 15),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      //   child: _crearApellidos(),
                      // ),
                      // Padding(
                      //   padding:
                      //       const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                      //   child: _crearFecha(context),
                      // ),
                      _crearEmail(),
                      SizedBox(height: 15),
                      _crearPass1(),
                      SizedBox(height: 15),
                      _crearPass2(_controllerPass1),
                      SizedBox(height: 80),
                      SizedBox(
                        width: 140,
                        child: RaisedButton(
                          elevation: 4,
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
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          onPressed: () async {
                            if (_registerKey.currentState.validate()) {
                              //Caso formulario correcto
                              // final passFinal = Crypt.sha256(
                              //     _pass1); //Encriptamos la contrasenya
                              //print(_pass1);
                              print("Voy a registrar al usuario");
                              //Comprobación registro correcto en backend
                              User usuario = new User(
                                  nombreUsuario: _controllerUsername.text,
                                  email: _controllerEmail.text,
                                  pass: _controllerPass1.text,
                                  pathFoto: null);
                              bool backendOK =
                                  await registrarUsuario(usuario, context);
                              if (backendOK) {
                                //Caso login correcto en backend
                                print("Te mando al homepage");
                                Navigator.pushReplacementNamed(
                                    context, 'home');
                              } else {
                                _errorRegisterBackend();
                              }
                            }
                          },
                          child: Text('Registrarse'),
                        ),
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

  //Campo "Nombre de usuario"
  Widget _crearNombreUsuario() {
    return TextFormField(
        controller: _controllerUsername,
        decoration: InputDecoration(
          hintText: 'NombreUsuario',
          suffixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          //Caso campo vacío
          if (value.isEmpty) {
            return 'Campo obligatorio';
          }
          //Caso contiene caracteres no alfanumericos
          RegExp usernamePattern = RegExp(r'^[a-zA-Z0-9&%=]+$');
          if (!usernamePattern.hasMatch(value)) {
            return 'El nombre de usuario solo puede contener letras y números';
          }
          return null;
        });
  }

  // Widget _crearApellidos() {
  //   return TextField(
  //     // autofocus: true,
  //     keyboardType: TextInputType.emailAddress,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
  //       hintText: 'Apellido',
  //       labelText: 'Apellido',
  //       suffixIcon: Icon(Icons.person),
  //     ),
  //     onChanged: (valor) {
  //       setState(() {
  //         _apellido = valor;
  //       });
  //     },
  //   );
  // }

  Widget _crearEmail() {
    return TextFormField(
        controller: _controllerEmail,
        keyboardType: TextInputType.emailAddress,
        decoration: InputDecoration(
          hintText: 'Correo electrónico',
          suffixIcon: Icon(Icons.person),
        ),
        validator: (value) {
          //Caso campo vacío
          if (value.isEmpty) {
            return 'Campo obligatorio';
          }
          //Caso email no valido
          RegExp emailPattern = RegExp(
              r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\"
              r".[a-zA-Z]+");
          if (!emailPattern.hasMatch(value)) {
            return 'Email no válido';
          }
          return null;
        });
  }

  // Widget _crearFecha(BuildContext context) {
  //   return TextField(
  //     enableInteractiveSelection: false,
  //     controller: _inputFieldDate,
  //     decoration: InputDecoration(
  //       border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
  //       hintText: 'Fecha de nacimiento',
  //       labelText: 'Fecha de nacimiento',
  //       suffixIcon: Icon(Icons.calendar_today),
  //     ),
  //     onTap: () {
  //       FocusScope.of(context).requestFocus(new FocusNode());
  //       _selectDate(context);
  //     },
  //   );
  // }

  // _selectDate(BuildContext context) async {
  //   DateTime picked = await showDatePicker(
  //       context: context,
  //       initialDate: new DateTime.now(),
  //       firstDate: new DateTime(2018),
  //       lastDate: new DateTime(2025));
  //   // locale: Locale('es', 'ES'));
  //   if (picked != null) {
  //     setState(() {
  //       _fechaNacimiento = picked.toString();
  //       _inputFieldDate.text = _fechaNacimiento;
  //     });
  //   }
  // }

  //Campo "Contraseña"
  Widget _crearPass1() {
    return TextFormField(
      controller: _controllerPass1,
      decoration: InputDecoration(
        hintText: 'Contraseña',
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        //Caso campo vacío
        if (value.isEmpty) {
          return 'Campo obligatorio';
        }
        //Caso longitud < 8
        if (value.length < 8) {
          return 'La contraseña debe tener al menos 8 caracteres';
        }
        //Caso no tiene al menos una mayúscula, una minúscula y un dígito
        if (!(value.contains(new RegExp(r'[A-Z]')) ||
            value.contains(new RegExp(r'[0-9]')) ||
            value.contains(new RegExp(r'[a-z]')))) {
          return 'La contraseña debe contener al menos una minúscula, '
              'mayúscula y dígito';
        }
        return null;
      },
      obscureText: true,
    );
  }

  //Campo "Repite la contraseña"
  Widget _crearPass2(TextEditingController pass1) {
    return TextFormField(
      controller: _controllerPass2,
      decoration: InputDecoration(
        hintText: 'Repite la contraseña',
        suffixIcon: Icon(Icons.person),
      ),
      validator: (value) {
        //Caso campo vacío
        if (value.isEmpty) {
          return 'Campo obligatorio';
        }
        if (value != pass1.text) {
          return 'Las contraseñas no coinciden';
        }
        return null;
      },
      obscureText: true,
    );
  }

  Future<dynamic> _errorRegisterBackend() {
    return showDialog(
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
                _controllerUsername.clear();
                _controllerEmail.clear();
                _controllerPass1.clear();
                _controllerPass2.clear();
              },
            ),
          ],
        );
      },
    );
  }
}
