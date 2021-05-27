import 'dart:io';

import 'package:flutter/material.dart';
import 'package:libros/src/storeUserInfo/SessionManager.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'newsModel.dart';
import 'package:http/http.dart' as http;

class RSSReader extends StatefulWidget {
  RSSReader();

  @override
  _RSSReaderState createState() => _RSSReaderState();
}

class _RSSReaderState extends State<RSSReader> {
  static String url = 'https://www.elperiodicodearagon.com/rss/section/23500';
  Uri rssUrl = Uri.parse(url);
  bool loaded = false;
  List<String> listaNegra = [];

  SessionManager s = new SessionManager();

  _RSSReaderState() {
    recuperarLista();
  }

  recuperarLista() {
    print("Entro a recuperar lista");

    SessionManager s = new SessionManager();
    s.getBlackList().then((value) {
      setState(() {
        listaNegra = List.from(value);
      });
    });

    for (var i = 0; i < listaNegra.length; i++) {
      print("Lo que recupero es: " + listaNegra[i]);
    }
  }

  List<NewsModel> limpiarNoticias(List<NewsModel> noticias) {
    List<NewsModel> limpia = [];
    if (listaNegra.isNotEmpty) {
      for (var i = 0; i < noticias.length; i++) {
        bool esta = false;
        for (var j = 0; j < listaNegra.length; j++) {
          if (listaNegra[j] == noticias[i].link) {
            esta = true; //Entonces noticias[i] no se debe mostrar
          }
        }
        if (!esta) {
          limpia.add(noticias[i]);
        }
      }
      return limpia;
    } else {
      print("Esta vacia");
      return noticias;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: fetchNews(),
          builder: (context, snap) {
            if (snap.hasData) {
              final List _news = snap.data;
              final List _newsClean = limpiarNoticias(_news);
              return ListView.separated(
                itemBuilder: (context, i) {
                  final NewsModel _item = _newsClean[i];
                  return ListTile(
                    onTap: () async {
                      _launchURL(_item.link);
                      SessionManager s = new SessionManager();

                      print("Voy a añadir una url a la lista negra");
                      s.addUrlToList(_item.link);
                      print("Se supone que se ha añadido");
                    },
                    title: Text('${_item.title}'),
                    subtitle: Text(
                      '${_item.description}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                },
                separatorBuilder: (context, i) => Divider(),
                itemCount: _news.length,
              );
            } else if (snap.hasError) {
              return Center(
                child: Text(snap.error.toString()),
              );
            } else {
              return Center(
                child: CircularProgressIndicator(),
              );
            }
          },
        ),
      ),
    );
  }

  Future fetchNews() async {
    final _response = await http.get(rssUrl);

    if (_response.statusCode == 200) {
      var _decoded = new RssFeed.parse(_response.body);
      return _decoded.items
          .map((item) => NewsModel(
              title: item.title,
              description: item.description,
              link: item.link))
          .toList();
    } else {
      throw HttpException('Failed to fetch the data');
    }
  }

  void _launchURL(String _url) async => await canLaunch(_url)
      ? await launch(_url)
      : throw 'Could not launch $_url';
}
