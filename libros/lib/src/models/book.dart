class Book {
  String _title;
  String _pathCover; //url portada
  String _synopsis;

  Book(String title, String pathCover, String synopsis) {
    _title = title;
    _pathCover = pathCover;
    _synopsis = synopsis;
  }
  String get title => _title;
  String get pathCover => _pathCover;
  String get synopsis => _synopsis;
}