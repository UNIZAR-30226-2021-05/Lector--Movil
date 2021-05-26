import 'package:flutter/material.dart';
import 'package:dart_twitter_api/twitter_api.dart';
import 'package:libros/src/pages/components/tweetCard.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  List<Tweet> tweets = [];

  final twitterApi = TwitterApi(
    client: TwitterClient(
      consumerKey: 'SVgJVcrNUiLpZ0GdTsYTf0w4K',
      consumerSecret: 'IwBd643m4zrbFDbqJpE86yaDvKvKa3WzE7tupeyL64aMHwxRgl',
      token: '1396845933514665989-AyndQhTLHzyELlwEt1wGfC0BBL48b5',
      secret: '81KDxrbEReSBzqp1GfU1qvYbRyGoUqM6TuCvuglm0dTZA',
    ),
  );

  bool loaded = false;

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
    if (loaded) {
      return Scaffold(
          appBar: AppBar(
            title: Text("Feed", style: new TextStyle(fontSize: 25)),
            centerTitle: true,
            backgroundColor: Colors.orange[700],
          ),
          body: ListView.builder(
              itemCount: tweets.length,
              itemBuilder: (context, index) {
                return tweetCard(tweets[index].fullText);
              }));
    } else {
      return Center(child: CircularProgressIndicator());
    }
  }
}
