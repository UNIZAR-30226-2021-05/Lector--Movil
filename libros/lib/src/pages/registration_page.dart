import 'package:flutter/material.dart';
import 'package:crypt/crypt.dart';
import 'package:libros/src/models/user.dart';
import 'package:libros/src/models/userFacade.dart';

class RegisterPage extends StatefulWidget {
  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String _nombreUsuario = '';
  String _email = '';
  String _pass1 = '';
  String _passConfirm = '';
  bool okC = false;
  bool okE = false;

  TextEditingController _inputFieldDate = new TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: Center(
        child: Container(
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [Colors.blue, Colors.red])),
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 90),
                child: Text(
                  'BrainBook',
                  style: TextStyle(color: Colors.white, fontSize: 30.0),
                ),
              ),
              SizedBox(height: 50),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: _crearNombreUsuario(),
              ),
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
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: _crearEmail(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: _crearPass1(),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 70, vertical: 10),
                child: _crearPass2(),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.all(20.0),
                child: Align(
                  alignment: Alignment.bottomLeft,
                  child: Row(
                    children: [
                      RaisedButton(
                        color: Colors.purpleAccent,
                        shape: RoundedRectangleBorder(
                            borderRadius:
                                BorderRadius.all(Radius.circular(20.0))),
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Icon(Icons.arrow_back_ios_sharp),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 175.0),
                        child: RaisedButton(
                          color: Colors.blue,
                          shape: RoundedRectangleBorder(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20.0))),
                          onPressed: () {
                            _validarPassword(_pass1, _passConfirm);
                            _validarEmail(_email);
                            if (okC && okE) {
                              // final passFinal = Crypt.sha256(
                              //     _pass1); //Encriptamos la contrasenya
                              print(_pass1);
                              print("Voy a registrar al usuario");
                              User usuario =
                                  new User(_nombreUsuario, _email, _pass1);
                              registrarUsuario(usuario, context);
                            }
                          },
                          child: Text('Registrarse'),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _crearNombreUsuario() {
    return TextField(
      // autofocus: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'NombreUsuario',
        labelText: 'NombreUsuario',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _nombreUsuario = valor;
        });
      },
    );
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
    return TextField(
      // autofocus: true,
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

  Widget _crearPass1() {
    return TextField(
      // autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Contraseña',
        labelText: 'Contraseña',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _pass1 = valor;
        });
      },
    );
  }

  Widget _crearPass2() {
    return TextField(
      // autofocus: true,
      obscureText: true,
      keyboardType: TextInputType.emailAddress,
      decoration: InputDecoration(
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(20.0)),
        hintText: 'Contraseña',
        labelText: 'Repita contraseña',
        suffixIcon: Icon(Icons.person),
      ),
      onChanged: (valor) {
        setState(() {
          _passConfirm = valor;
        });
      },
    );
  }

  void _validarEmail(String _email) async {
    bool emailValid = RegExp(
            r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
        .hasMatch(_email);
    if (!emailValid) {
      okE = false;
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Email incorrecto'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      okE = true;
    }
  }

  void _validarPassword(String _pass1, String _pass2) async {
    if (_pass1 == null || _pass1.isEmpty) {
      okC = false;
    }

    bool hasUppercase = _pass1.contains(new RegExp(r'[A-Z]'));
    bool hasDigits = _pass1.contains(new RegExp(r'[0-9]'));
    bool hasLowercase = _pass1.contains(new RegExp(r'[a-z]'));

    bool hasMinLength = _pass1.length > 7;
    bool equals = _pass1 == _pass2;

    if (!(hasDigits & hasUppercase & hasLowercase & hasMinLength)) {
      okC = false;
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Contraseña no segura, cree una contraseña más segura'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else if (!equals) {
      okC = false;
      return showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text('Las contraseñas no coinciden'),
            actions: <Widget>[
              FlatButton(
                child: Text('OK'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          );
        },
      );
    } else {
      okC = true;
    }
  }
}
