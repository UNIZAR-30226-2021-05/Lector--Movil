class Bookmark {
  String libro;
  int usuario;
  String cuerpo;
  bool esAnotacion;
  int id;
  int offset;
  String titulo;

  Bookmark(
      {this.libro,
      this.usuario,
      this.cuerpo,
      this.esAnotacion,
      this.id,
      this.offset,
      this.titulo});

  Bookmark.fromJson(Map<String, dynamic> json) {
    libro = json['Libro'];
    usuario = json['Usuario'];
    cuerpo = json['cuerpo'];
    esAnotacion = json['esAnotacion'];
    id = json['id'];
    offset = json['offset'];
    titulo = json['titulo'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['Libro'] = this.libro;
    data['Usuario'] = this.usuario;
    data['cuerpo'] = this.cuerpo;
    data['esAnotacion'] = this.esAnotacion;
    data['id'] = this.id;
    data['offset'] = this.offset;
    data['titulo'] = this.titulo;
    return data;
  }
}
