import 'package:flutter/material.dart';
import 'package:libros/src/app_routes.dart';
import 'package:libros/src/pages/theme/theme_config.dart';
import 'package:shared_preferences/shared_preferences.dart';

SharedPreferences sp;

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  sp = await SharedPreferences.getInstance();
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'BrainBook',
      theme: ThemeConfig.lightTheme,
      // home: HomePage(),
      initialRoute: 'home',
      routes: getPages(),
    );
  }
}


