class User {
  String nombreUsuario = '';
  String email = '';
  String pass = '';
  String pathPhoto = '';

  User({this.nombreUsuario, this.email, this.pass, this.pathPhoto});

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
        nombreUsuario: json['username'],
        email: json['email'],
        pathPhoto: json['pathPhoto']);
  }
}
