class Book {
  String _title;
  String _author;
  String _pathCover; //url portada
  String _synopsis;

  Book(String title, String author,  String pathCover,
      String synopsis,
     ) {
    _title = title;
    _author = author;
    _pathCover = pathCover;
    _synopsis = synopsis;
  }
  String get title => _title;
  String get author => _author;
  String get pathCover => _pathCover;
  String get synopsis => _synopsis;
}