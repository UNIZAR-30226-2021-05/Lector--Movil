import 'package:flutter/Material.dart';
import 'package:libros/src/pages/first_page.dart';
import 'package:libros/src/pages/registration_page.dart';

Map<String, WidgetBuilder> getPages() {
  return <String, WidgetBuilder>{
    '/': (BuildContext context) => FirstPage(),
    'register': (BuildContext context) => RegisterPage(),
  };
}
