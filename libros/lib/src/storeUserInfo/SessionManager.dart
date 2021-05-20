import 'package:shared_preferences/shared_preferences.dart';

class SessionManager {
  String _key = "";
  String _nombreUsuario = '';
  String _email = '';
  String _pathPhoto = '';

  dynamic setKey(String key) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString("key", key);
    _key = key;
  }

  Future<String> getKey() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _key = prefs.getString("key");

    return _key;
  }

  dynamic setNombreUsuario(String nombre) async {
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
    prefs.setString("pathFoto", path);
    _pathPhoto = path;
    var mi = prefs.getString("pathFoto");
    print(mi);
  }

  Future<String> getpathPhoto() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    _pathPhoto = prefs.getString("pathFoto");
    return _pathPhoto;
  }
}
