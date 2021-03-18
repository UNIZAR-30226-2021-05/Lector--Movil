import 'dart:ui';

import 'package:flutter/material.dart';
/*
  Esta pantalla muestra la configuracion del usuario
 */

class ChangePassword extends StatefulWidget {
  @override
  _ChangePasswordState createState() => _ChangePasswordState();
}

//No incluir Scaffold (lo añade HomePage)
class _ChangePasswordState extends State<ChangePassword> {
  String _passActual = '';
  String _passNueva1 = '';
  String _passNueva2 = '';
  var _controllerActual = TextEditingController();
  var _controllerNueva1 = TextEditingController();
  var _controllerNueva2 = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        resizeToAvoidBottomInset: false,
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
                          'Editar contraseña',
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
                            width: 100.0,
                            height: 100.0,
                            decoration: new BoxDecoration(
                                shape: BoxShape.circle,
                                image: new DecorationImage(
                                    fit: BoxFit.cover,
                                    image: new NetworkImage(
                                        'https://img.huffingtonpost.com/asset/5ead5c6e2500006912eb0beb.png?cache=VGVQqRsEJs&ops=1200_630')))),
                      ),
                      SizedBox(height: 20),
                      Text("Facundo Garcia Pimienta", textScaleFactor: 1.4),
                      SizedBox(height: 10),
                      Text("facundo@gmail.com", textScaleFactor: 1.1),
                      SizedBox(height: 15),
                      _crearCamposDeTexto()
                    ],
                  ))
                ]))));
  }

  Widget _crearCamposDeTexto() {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.only(top: 10.0),
          child: TextField(
            // autofocus: true,
            controller: _controllerActual,
            obscureText: true,
            keyboardType: TextInputType.visiblePassword,
            decoration: InputDecoration(
              border:
                  OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
              hintText: 'Contraseña',
              labelText: 'Contraseña actual',
              suffixIcon: Icon(Icons.lock),
            ),
            onChanged: (valor) {
              setState(() {
                _passActual = valor;
              });
            },
          ),
        ),
        SizedBox(height: 20),
        TextField(
          // autofocus: true,
          controller: _controllerNueva2,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'Contraseña',
            labelText: 'Contraseña Nueva',
            suffixIcon: Icon(Icons.lock),
          ),
          onChanged: (valor) {
            setState(() {
              _passActual = valor;
            });
          },
        ),
        SizedBox(height: 20),
        TextField(
          // autofocus: true,
          controller: _controllerNueva1,
          obscureText: true,
          keyboardType: TextInputType.visiblePassword,
          decoration: InputDecoration(
            border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(12.0)),
            hintText: 'Confirmar contraseña',
            labelText: 'Confirmar contraseña nueva',
            suffixIcon: Icon(Icons.lock),
          ),
          onChanged: (valor) {
            setState(() {
              _passActual = valor;
            });
          },
        ),
        Padding(
          padding: const EdgeInsets.only(top: 40.0),
          child: SizedBox(
            width: 200,
            child: RaisedButton(
              onPressed: () {},
              elevation: 4,
              textColor: Colors.white,
              color: Colors.green[600],
              padding: const EdgeInsets.all(12.0),
              child: Text(
                'Confirmar',
              ),
            ),
          ),
        )
      ],
    );
  }
}
