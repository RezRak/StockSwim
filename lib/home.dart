import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:fl_chart/fl_chart.dart';

class Home extends StatefulWidget {
  const Home({Key? key}) : super(key: key);

  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final String _apiKey = 'ct7451pr01qr3sdtldr0ct7451pr01qr3sdtldrg';
  final List<String> _symbols = ['NVDA', 'TSLA', 'SPY', 'AAPL'];
  Map<String, dynamic>? _nvidiaData;
  Map<String, dynamic>? _teslaData;
  Map<String, dynamic>? _sp500Data;
  Map<String, dynamic>? _appleData;
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    setState(() {
      _isLoading = true;
    });

    try {
      for (String symbol in _symbols) {
        final url = 'https://finnhub.io/api/v1/quote?symbol=$symbol&token=$_apiKey';
        final response = await http.get(Uri.parse(url));
        if (response.statusCode == 200) {
          final data = json.decode(response.body);
          setState(() {
            if (symbol == 'NVDA') {
              _nvidiaData = data;
            } else if (symbol == 'TSLA') {
              _teslaData = data;
            } else if (symbol == 'SPY') {
              _sp500Data = data;
            } else if (symbol == 'AAPL') {
              _appleData = data;
            }
          });
        } else {
          throw Exception('Failed to load data for $symbol');
        }
      }

      setState(() {
        _isLoading = false;
      });
    } catch (e) {
      setState(() {
        _isLoading = false;
      });
    }
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
        title: const Text("Home", style: TextStyle(color: Colors.white)),
      ),
      body: _isLoading
          ? const Center(
              child: CircularProgressIndicator(
                valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
              ),
            )
          : (_nvidiaData != null &&
                  _teslaData != null &&
                  _sp500Data != null &&
                  _appleData != null)
              ? Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Text(
                        'Nvidia',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Stack(
                        alignment: Alignment.topCenter,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 16.0, right: 16.0, bottom: 32.0, top: 32.0),
                            child: BarChart(
                              BarChartData(
                                minY: _calculateMinY(_nvidiaData!),
                                maxY: _calculateMaxY(_nvidiaData!),
                                titlesData: FlTitlesData(
                                  leftTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  rightTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  topTitles: AxisTitles(
                                    sideTitles: SideTitles(showTitles: false),
                                  ),
                                  bottomTitles: AxisTitles(
                                    sideTitles: SideTitles(
                                      showTitles: true,
                                      getTitlesWidget: (value, meta) {
                                        switch (value.toInt()) {
                                          case 0:
                                            return const Text(
                                              'Low',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          case 1:
                                            return const Text(
                                              'Current',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          case 2:
                                            return const Text(
                                              'High',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          case 3:
                                            return const Text(
                                              'Open',
                                              style: TextStyle(color: Colors.white),
                                            );
                                          default:
                                            return const Text('');
                                        }
                                      },
                                    ),
                                  ),
                                ),
                                borderData: FlBorderData(show: false),
                                gridData: FlGridData(show: false),
                                barGroups: _buildBarGroups(_nvidiaData!),
                              ),
                            ),
                          ),
                          Positioned(
                            top: 40,
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildBarValue(_nvidiaData!['l'] as double, Colors.blue),
                                _buildBarValue(_nvidiaData!['c'] as double, Colors.green),
                                _buildBarValue(_nvidiaData!['h'] as double, Colors.red),
                                _buildBarValue(_nvidiaData!['o'] as double, Colors.orange),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    Expanded(
                      flex: 1,
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          _buildAdditionalItem(
                              'Tesla', _teslaData!['c'].toString(), Colors.blue),
                          _buildAdditionalItem(
                              'S&P 500', _sp500Data!['c'].toString(), Colors.green),
                          _buildAdditionalItem(
                              'Apple', _appleData!['c'].toString(), Colors.red),
                        ],
                      ),
                    ),
                  ],
                )
              : const Center(
                  child: Text(
                    'Failed to load data',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
      bottomNavigationBar: Container(
        color: Colors.black,
        child: Row(
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
              child: const Icon(Icons.home, color: Colors.white),
            ),
            TextButton(
              onPressed: () {},
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.business, color: Colors.white),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacement(
                  context,
                  MaterialPageRoute(builder: (context) => const Home()),
                );
              },
              style: TextButton.styleFrom(
                backgroundColor: Colors.transparent,
              ),
              child: const Icon(Icons.favorite, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

  double _calculateMinY(Map<String, dynamic> data) {
    final lowPrice = data['l'] as double;
    final currentPrice = data['c'] as double;
    final highPrice = data['h'] as double;
    final openPrice = data['o'] as double;

    final minValue =
        [lowPrice, currentPrice, highPrice, openPrice].reduce((a, b) => a < b ? a : b);
    return minValue * 0.95;
  }

  double _calculateMaxY(Map<String, dynamic> data) {
    final lowPrice = data['l'] as double;
    final currentPrice = data['c'] as double;
    final highPrice = data['h'] as double;
    final openPrice = data['o'] as double;

    final maxValue =
        [lowPrice, currentPrice, highPrice, openPrice].reduce((a, b) => a > b ? a : b);
    return maxValue * 1.05;
  }

  Widget _buildBarValue(double value, Color color) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16.0),
      child: Text(
        value.toStringAsFixed(2),
        style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: color),
      ),
    );
  }

  Widget _buildAdditionalItem(String title, String value, Color color) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          title,
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.white),
        ),
        const SizedBox(height: 8),
        Icon(Icons.show_chart, size: 30, color: color),
        const SizedBox(height: 8),
        Text(
          value,
          style: TextStyle(fontSize: 16, color: Colors.grey[300]),
        ),
      ],
    );
  }

  List<BarChartGroupData> _buildBarGroups(Map<String, dynamic> data) {
    final double lowPrice = data['l'] as double;
    final double currentPrice = data['c'] as double;
    final double highPrice = data['h'] as double;
    final double openPrice = data['o'] as double;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [
          BarChartRodData(
            toY: lowPrice,
            color: Colors.blue,
            width: 12,
          ),
        ],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [
          BarChartRodData(
            toY: currentPrice,
            color: Colors.green,
            width: 12,
          ),
        ],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [
          BarChartRodData(
            toY: highPrice,
            color: Colors.red,
            width: 12,
          ),
        ],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [
          BarChartRodData(
            toY: openPrice,
            color: Colors.orange,
            width: 12,
          ),
        ],
      ),
    ];
  }
}
