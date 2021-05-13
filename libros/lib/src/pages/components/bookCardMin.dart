import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';

Widget bookCardMin(Book book, String pageName, BuildContext context) {
  return GestureDetector(
    onTap: () {
      print(book.title);
      Navigator.pushNamed(context, pageName, arguments: {
        'book': book,
      });
    },
    child: Card(
        elevation: 0.0,
        child: Row(
          children: <Widget>[
            Container(
              height: 170,
              width: 105,
              child: Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child: ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Hero(
                    tag: book.title,
                    child: Image.network(
                      book.pathCover,
                      fit: BoxFit.fill,
                    ),
                  ),
                ),
              ),
            ),
          ],
        )),
  );
}
