import 'dart:io';

import 'package:flutter/material.dart';
import 'package:webfeed/domain/rss_feed.dart';
import 'package:url_launcher/url_launcher.dart';
import 'NewsModel.dart';
import 'package:http/http.dart' as http;

class RSSReader extends StatelessWidget {
  static String url = 'https://www.elperiodicodearagon.com/rss/section/23500';
  Uri rssUrl = Uri.parse(url);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        child: FutureBuilder(
          future: fetchNews(),
          builder: (context, snap) {
            if (snap.hasData) {
              final List _news = snap.data;
              return ListView.separated(
                itemBuilder: (context, i) {
                  final NewsModel _item = _news[i];
                  return ListTile(
                    onTap: () {
                      _launchURL(_item.link);
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
      print(_response.body);
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
