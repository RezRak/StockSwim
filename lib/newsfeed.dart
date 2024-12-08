import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:stockapp/home.dart';
import 'package:stockapp/watchlist.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}



class _NewsFeedState extends State<NewsFeed> {
  final String _apiKey = 'ct7451pr01qr3sdtldr0ct7451pr01qr3sdtldrg';
  List<Map<String, dynamic>> _latestNews = [];



  @override
  void initState() {
    super.initState();
    _fetchLatestNews();
  }

  _launchURL(myURL) async {
   final Uri url = Uri.parse(myURL);
   if (!await launchUrl(url)) {
        throw Exception('Could not launch url');
    }
} 


  Future<void> _fetchLatestNews() async {
    final url = 'https://finnhub.io/api/v1/news?category=crypto&token=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final List<dynamic> newsList = json.decode(response.body);

        setState(() {
          _latestNews = newsList.take(3).map((news) {
            return {
              'headline': news['headline'],
              'url': news['url'],
              'image': news['image'], 
            };
          }).toList();
        });
      } 
    } catch (e) {
      print('Error fetching news: $e');
    }
  }
  
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
        backgroundColor: Colors.black,
        title: const Text("Newsfeed", style: TextStyle(color: Colors.black)),
      ),
      body: Column(
        children: [
          const SizedBox(height: 30),
          if (_latestNews.length > 0)
            ElevatedButton(
              onPressed: () {
              _launchURL(_latestNews[0]['url']);
              },
              child: Text(_latestNews[0]['headline']),
          ),
          if (_latestNews.length > 1)
            ElevatedButton(
              onPressed: () {
                _launchURL(_latestNews[1]['url']);
              },
              child: Text(_latestNews[1]['headline']),
          ),
          if (_latestNews.length > 2)
          ElevatedButton(
            onPressed: () {
                _launchURL(_latestNews[2]['url']);
            },
              child: Text(_latestNews[2]['headline']),
          ),
          
          const SizedBox(height: 5),
          const SizedBox(height: 10),
        const Spacer(),
          
          Container(height: 2, color: Colors.white, width: double.infinity),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
            );
              },
              style: TextButton.styleFrom(
                backgroundColor: const Color.fromARGB(40, 49, 49, 49),
              ),
              child: const Icon(Icons.home),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WatchList()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.business),
            ),
            TextButton(
              onPressed: () {
                  Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsFeed()),
                );
            },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.favorite),
            ),
          ],
        ),
      ],
    ),
  );
}
}
