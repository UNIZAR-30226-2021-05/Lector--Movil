import 'package:flutter/material.dart';
import 'package:dart_twitter_api/twitter_api.dart';

class FeedPage extends StatefulWidget {
  FeedPage({Key key}) : super(key: key);

  @override
  _FeedPageState createState() => _FeedPageState();
}

class _FeedPageState extends State<FeedPage> {
  final twitterApi = TwitterApi(
    client: TwitterClient(
      consumerKey: 'your_consumer_key',
      consumerSecret: 'your_consumer_secret',
      token: 'your_token',
      secret: 'your_secret',
    ),
  );

  Future<void> getTweets() async {
    try {
      // Get the last 200 tweets from your home timeline
      final homeTimeline = await twitterApi.timelineService.homeTimeline(
        count: 200,
      );

      // Print the text of each Tweet
      homeTimeline.forEach((tweet) => print(tweet.fullText));

      // Update your status (tweet)
      await twitterApi.tweetService.update(
        status: 'Hello world!',
      );
    } catch (error) {
      print('error while requesting home timeline: $error');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Text("Aqui ira la feed de twitter ...")),
    );
  }
}
