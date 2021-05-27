import 'package:flutter/material.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:libros/src/models/RSSReader.dart';
import 'package:libros/src/pages/components/tweetCard.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Tweet> tweets = [];
  Map data = {}; //Índice del tabBar especificado como argumento
  int tabIndex = 0; //Por defecto el tabBar muestra los libros (índice 0)

  final twitterApi = TwitterApi(
    client: TwitterClient(
      consumerKey: 'SVgJVcrNUiLpZ0GdTsYTf0w4K',
      consumerSecret: 'IwBd643m4zrbFDbqJpE86yaDvKvKa3WzE7tupeyL64aMHwxRgl',
      token: '1396845933514665989-AyndQhTLHzyELlwEt1wGfC0BBL48b5',
      secret: '81KDxrbEReSBzqp1GfU1qvYbRyGoUqM6TuCvuglm0dTZA',
    ),
  );

  bool loaded = false;

  final List<Tab> tabs = <Tab>[
    Tab(text: 'Tweets'),
    Tab(text: 'RSS'),
  ];

  _FeedPageState() {
    obtenerTweets();
  }

  obtenerTweets() {
    getTweets().then((value) {
      setState(() {
        tweets = value;
        loaded = true;
      });
    });
  }

  Future<List<Tweet>> getTweets() async {
    try {
      // Get the last 200 tweets from your home timeline
      final homeTimeline = await twitterApi.timelineService.homeTimeline(
        count: 200,
      );
      return homeTimeline;
    } catch (error) {
      print('error while requesting home timeline: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    data = ModalRoute.of(context).settings.arguments;
    if (data != null && data.containsKey('tabIndex')) {
      //Caso especifico el índice del tab que quiero mostrar
      tabIndex = data['tabIndex'];
      data.remove('tabIndex');
    }
    if (loaded)
      return DefaultTabController(
        length: tabs.length,
        initialIndex: tabIndex,
        child: Scaffold(
          appBar: AppBar(
            title: Padding(
              padding: const EdgeInsets.fromLTRB(0.0, 10.0, 30.0, 0.0),
              child: Text(
                "Noticias",
                style: TextStyle(
                  fontSize: 25.0,
                  fontWeight: FontWeight.normal,
                ),
              ),
            ),
            bottom: TabBar(indicatorColor: Colors.blue, tabs: tabs),
          ),
          body: Padding(
              padding: const EdgeInsets.fromLTRB(20.0, 0.0, 30.0, 0.0),
              child: TabBarView(
                children: [
                  _buildTw(),
                  _buildRSS(),
                ],
              )),
        ),
      );
    else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildTw() {
    if (loaded) {
      return Scaffold(
          body: ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                return tweetCard(tweets[index].fullText);
              }));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }

  Widget _buildRSS() {
    if (loaded) {
      return RSSReader();
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
