import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

Widget tweetCard(String texto) {
  return GestureDetector(
    onTap: () {
      _launchURL("https://twitter.com/BookLector");
    },
    child: Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      margin: EdgeInsets.all(13),
      elevation: 7,
      child: Column(
        children: <Widget>[
          ListTile(
            contentPadding: EdgeInsets.fromLTRB(15, 10, 25, 0),
            title: Padding(
              padding: const EdgeInsets.only(bottom: 10.0),
              child: RichText(
                text: new TextSpan(
                  style: new TextStyle(
                    fontSize: 14.0,
                    color: Colors.black,
                  ),
                  children: <TextSpan>[
                    new TextSpan(
                        text: 'LectorBrainBook     ',
                        style: new TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 18)),
                    new TextSpan(
                        text: '@BookLector',
                        style:
                            new TextStyle(fontSize: 15, color: Colors.black)),
                  ],
                ),
              ),
            ),
            subtitle: Text(texto,
                style: TextStyle(fontSize: 18, color: Colors.black)),
            leading: SizedBox(
                height: 40.0,
                width: 40.0,
                child: Image.asset("assets/logo.png")),
          ),
        ],
      ),
    ),
  );
}

void _launchURL(String _url) async =>
    await canLaunch(_url) ? await launch(_url) : throw 'Could not launch $_url';
