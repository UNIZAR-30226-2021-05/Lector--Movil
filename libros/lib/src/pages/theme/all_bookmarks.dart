import 'package:flutter/material.dart';
import 'package:libros/src/models/Bookmarks.dart';
import 'package:libros/src/models/book.dart';
import 'package:libros/src/models/bookFacade.dart';
import 'package:libros/src/pages/book_page.dart';

class AllBookmarks extends StatefulWidget {
  String isbn = '';
  AllBookmarks(this.isbn);

  @override
  _AllBookmarksState createState() => _AllBookmarksState();
}

class _AllBookmarksState extends State<AllBookmarks> {
  List<Bookmark> bm = [];
  bool loaded = false;

  @override
  void initState() {
    super.initState();
    pedirBookmarks();
  }

  @override
  Widget build(BuildContext context) {
    if (loaded) {
      return Scaffold(
          appBar: AppBar(title: Text("Bookmarks")),
          body: ListView.separated(
            itemBuilder: (context, i) {
              final Bookmark _item = bm[i];
              return ListTile(
                onTap: () async {
                  updateUserBookState(_item.libro, _item.offset, true);
                  Book aux = await crearLibro(_item.libro);
                  Navigator.pushNamed(context, 'book', arguments: {
                    'book': aux,
                  });
                },
                title: Text('${_item.titulo}'),
                subtitle: Text(
                  '${_item.cuerpo}',
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            },
            separatorBuilder: (context, i) => Divider(),
            itemCount: bm.length,
          ));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  void pedirBookmarks() async {
    getBookmarks(widget.isbn).then((value) {
      setState(() {
        bm = List.from(value);
        loaded = true;
      });
    });
  }
}
