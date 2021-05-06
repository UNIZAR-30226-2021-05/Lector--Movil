class Book {
  String isbn;
  String title;
  String author;
  String url;
  String pathCover; //url portada
  String synopsis;
  //List<String> genres = [];

  Book(
    this.isbn,
    this.title,
    this.author,
    this.url,
    this.pathCover,
    this.synopsis,
  );

  factory Book.fromJson(Map<String, dynamic> json) {
    return Book(json['ISBN'], json['titulo'], json['autor'], json['pathLibro'],
        json['portada'], json['sinopsis']);
  }
}
