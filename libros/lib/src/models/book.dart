class Book {
  String _isbn;
  String _title;
  String _author;
  String _pathCover; //url portada
  String _synopsis;
  List<String> _genres = [];

  Book(String isbn, String title, String author, String pathCover,
      String synopsis, List<String> genres) {
    _isbn = isbn;
    _title = title;
    _author = author;
    _pathCover = pathCover;
    _synopsis = synopsis;
    _genres.addAll(genres);
    print("AQUI: " + _genres.toString());
  }
  String get isbn => _isbn;
  String get title => _title;
  String get author => _author;
  String get pathCover => _pathCover;
  String get synopsis => _synopsis;
  List<String> get genres => _genres;
}
