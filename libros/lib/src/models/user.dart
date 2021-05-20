class User {
  String nombreUsuario = '';
  String email = '';
  String pass = '';
  String pathFoto = 'nada.jpg';

  User({this.nombreUsuario, this.email, this.pass, this.pathFoto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nombreUsuario: json['username'],
        email: json['email'],
        pathFoto: json['pathFoto']);
  }
}
