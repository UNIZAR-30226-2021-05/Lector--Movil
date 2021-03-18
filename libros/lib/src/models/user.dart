class User {
  String _nombreUsuario = '';
  String _email = '';
  String _pass = '';

  User(String username, String email, String pass) {
    _nombreUsuario = username;
    _email = email;
    _pass = pass;
  }

  String get nombreUsuario => _nombreUsuario;
  String get email => _email;
  String get pass => _pass;
}
