import 'package:flutter/material.dart';
import 'package:libros/src/models/book.dart';
Widget bookCard(Book book, String pageName, BuildContext context) {
  return GestureDetector(
    onTap: () {
      print(book.title);
      Navigator.pushNamed(context, pageName, arguments: {
        'book' : book,
      }
      );
    },
    child: Container(
      height:180,
      padding: EdgeInsets.all(4.0),
      child: Card(
          elevation: 0.0,
          child:Row(
            children: <Widget>[
              Material(
                elevation: 10.0,
                borderRadius: BorderRadius.circular(10.0),
                child:ClipRRect(
                  borderRadius: BorderRadius.all(
                    Radius.circular(10.0),
                  ),
                  child: Hero(
                    tag: book.title,
                    child: Image.network(book.pathCover,
                    ),
                  ),
                ),
              ),
              SizedBox(width: 10),
              Flexible(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                    Text(
                      book.title,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(
                      book.author,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: 17.0,
                        fontWeight: FontWeight.bold,
                        color:Colors.blue,
                      ),
                    ),
                    SizedBox(height: 10.0),
                    Text(book.synopsis,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color:Colors.grey[600],
                      ),
                      maxLines: 3,
                    )
                  ],
                ),
              )

            ],
          )
      ),
    ),
  );
}