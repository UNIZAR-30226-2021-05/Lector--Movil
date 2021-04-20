import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  String _nombreUsuario = '';
  String _email = '';
  String _pathPhoto = '';


  Future<void> setNombreUsuario(String nombre) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("nombreUsuario", nombre);
    _nombreUsuario = nombre;
  }

  Future<String> getNombreUsuario() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _nombreUsuario = prefs.getString("nombreUsuario");
    return _nombreUsuario;
  }

  Future<void> setEmail(String email) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("email", email);
    _email = email;
  }

  Future<String> getEmail() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _email = prefs.getString("email");
    return _email;
  }

  Future<void> setPathPhoto(String path) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("_pathPhoto", path);
    _pathPhoto = path;
  }

  Future<String> getpathPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _pathPhoto = prefs.getString("pathPhoto");
    return _pathPhoto;
  }
}
