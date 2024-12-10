import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:stockapp/home.dart';
import 'package:stockapp/newsfeed.dart';
import 'package:http/http.dart' as http;

class WatchList extends StatefulWidget {
  const WatchList({super.key});

  @override
  _WatchListState createState() => _WatchListState();
}

class _WatchListState extends State<WatchList> {
  final TextEditingController _tickerController = TextEditingController();
  final List<Map<String, dynamic>> _watchlist = [];
  
  final String _apiKey = 'ct7451pr01qr3sdtldr0ct7451pr01qr3sdtldrg'; 

  Future<Map<String, dynamic>> _fetchStockData(String ticker) async {
    ticker = ticker.toUpperCase().trim();
    final profileUrl = 'https://finnhub.io/api/v1/stock/profile2?symbol=$ticker&token=$_apiKey';
    final quoteUrl = 'https://finnhub.io/api/v1/quote?symbol=$ticker&token=$_apiKey';

    try {
      final profileResp = await http.get(Uri.parse(profileUrl));
      final quoteResp = await http.get(Uri.parse(quoteUrl));

      if (profileResp.statusCode == 200 && quoteResp.statusCode == 200) {
        final profileData = json.decode(profileResp.body);
        final quoteData = json.decode(quoteResp.body);
        
        if (profileData == null || profileData['name'] == null || quoteData == null) {
          throw Exception('Invalid Ticker');
        }

        final name = profileData['name'] ?? ticker;
        final currentPrice = quoteData['c'];
        final lowPrice = quoteData['l'];
        final highPrice = quoteData['h'];

        if (currentPrice == null || lowPrice == null || highPrice == null) {
          throw Exception('Missing quote data');
        }

        return {
          'ticker': ticker,
          'name': name,
          'currentPrice': currentPrice.toString(),
          'lowPrice': lowPrice.toString(),
          'highPrice': highPrice.toString(),
        };
      } else {
        throw Exception('Failed to fetch data');
      }
    } catch (e) {
      throw Exception('Error fetching stock data: $e');
    }
  }

  void _addStock() async {
    final ticker = _tickerController.text.trim().toUpperCase();
    if (ticker.isEmpty) return;

    if (_watchlist.length >= 5) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('You can only add up to 5 stocks.')),
      );
      return;
    }

    if (_watchlist.any((stock) => stock['ticker'] == ticker)) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Stock is already on the watchlist.')),
      );
      return;
    }

    try {
      final data = await _fetchStockData(ticker);
      setState(() {
        _watchlist.add(data);
      });
      _tickerController.clear();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(e.toString().replaceAll('Exception:', '').trim())),
      );
    }
  }

  void _removeStock(int index) {
    setState(() {
      _watchlist.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.white, height: 2.0),
        ),
        backgroundColor: Colors.black,
        title: const Text("Watchlist", style: TextStyle(color: Colors.white)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            color: Colors.grey[900],
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _tickerController,
                    style: const TextStyle(color: Colors.white),
                    decoration: InputDecoration(
                      hintText: 'Enter stock ticker (ex: TSLA',
                      hintStyle: TextStyle(color: Colors.grey[400]),
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey[700]!),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.blue[300]!),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                ElevatedButton(
                  onPressed: _addStock,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue[700],
                  ),
                  child: const Text('Submit', style: TextStyle(color: Colors.white)),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          if (_watchlist.isEmpty)
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(
                "Add stocks to your watchlist.",
                style: TextStyle(fontSize: 16, color: Colors.white),
                textAlign: TextAlign.center,
              ),
            ),
          if (_watchlist.isNotEmpty)
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: _watchlist.length,
                itemBuilder: (context, index) {
                  final stock = _watchlist[index];
                  return Card(
                    color: Colors.grey[900],
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(
                              '${stock['name']} (${stock['ticker']})',
                              style: const TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.bold,
                              ),
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              Text('Current: \$${stock['currentPrice']}', style: const TextStyle(color: Colors.white)),
                              Text('Low: \$${stock['lowPrice']}', style: const TextStyle(color: Colors.white70)),
                              Text('High: \$${stock['highPrice']}', style: const TextStyle(color: Colors.white70)),
                            ],
                          ),
                          const SizedBox(width: 10),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _removeStock(index),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
            ),
          Container(height: 2, color: Colors.white, width: double.infinity),
          Container(
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
        ],
      ),
    );
  }
}