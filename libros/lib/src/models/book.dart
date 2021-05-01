class Book {
  String isbn;
  String title;
  String author;
  String pathCover; //url portada
  String synopsis;
  //List<String> genres = [];

  Book(
    this.isbn,
    this.title,
    this.author,
    this.pathCover,
    this.synopsis,
  );

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(json['ISBN'], json['titulo'], json['autor'], json['portada'],
        json['sinopsis']);
  }
}
