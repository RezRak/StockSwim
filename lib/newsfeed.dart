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

  _launchURL(String myURL) async {
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
          _latestNews = newsList.take(5).map((news) {
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text(
          "Newsfeed",
          style: TextStyle(color: Colors.white),
        ),
      ),
      body: _latestNews.isEmpty
          ? const Center(
              child: CircularProgressIndicator(color: Colors.white),
            )
          : ListView.builder(
              padding: const EdgeInsets.all(16),
              itemCount: _latestNews.length,
              itemBuilder: (context, index) {
                final item = _latestNews[index];
                return Card(
                  color: Colors.grey[900],
                  margin: const EdgeInsets.symmetric(vertical: 8),
                  child: ListTile(
                    leading: (item['image'] != null && item['image'].toString().isNotEmpty)
                        ? Image.network(
                            item['image'],
                            width: 60,
                            height: 60,
                            fit: BoxFit.cover,
                          )
                        : const SizedBox(width: 60),
                    title: Text(
                      item['headline'],
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                    ),
                    trailing: const Icon(Icons.launch, color: Colors.white),
                    onTap: () => _launchURL(item['url']),
                  ),
                );
              },
            ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            IconButton(
              icon: const Icon(Icons.home),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.business),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const NewsFeed()),
                );
              },
            ),
            IconButton(
              icon: const Icon(Icons.favorite),
              color: Colors.white,
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const WatchList()),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}