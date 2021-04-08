import 'package:flutter/material.dart';
import 'package:libros/src/pages/mainPages/home_page.dart';
import 'package:libros/src/pages/login_page.dart';
import 'package:libros/src/pages/registration_page.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/bg.jpg"),
            fit: BoxFit.fill,
          ),
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            SizedBox(height: 280),
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
            SizedBox(height: 40),
            SizedBox(
              width: 150,
              child: RaisedButton(
                  onPressed: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) => LoginPage()));
                  },
                  elevation: 4,
                  textColor: Colors.white,
                  color: Colors.green,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Iniciar sesión',
                  )),
            ),
            SizedBox(height: 9),
            SizedBox(
                width: 150,
                child: RaisedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => RegisterPage()),
                    );
                  },
                  elevation: 4,
                  textColor: Colors.white,
                  color: Colors.blue,
                  padding: const EdgeInsets.all(12.0),
                  child: Text(
                    'Registrarse',
                  ),
                )),
            Container(
              margin: EdgeInsets.only(top: 100),
              child: Text(
                'BrainBook ©',
                style: TextStyle(color: Colors.white, fontSize: 10.0),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
