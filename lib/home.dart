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
  final String _symbol = 'TSLA'; 
  Map<String, dynamic>? _stockData;
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

    final url = 'https://finnhub.io/api/v1/quote?symbol=$_symbol&token=$_apiKey';

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        setState(() {
          _stockData = json.decode(response.body);
          _isLoading = false;
        });
      } else {
        throw Exception('Failed to load stock data');
      }
    } catch (e) {
      print('Error fetching stock data: $e');
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(4.0),
          child: Container(color: Colors.black, height: 2.0),
        ),
        backgroundColor: Colors.white,
        title: const Text("Home", style: TextStyle(color: Colors.black)),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Image.asset(
              'Image/FTT.png',
              height: 40,
              width: 40,
            ),
          ),
        ],
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _stockData != null
              ? Column(
                  children: [
                    Container(height: 2, color: Colors.black, width: double.infinity),
                    Expanded(
                      child: BarChart(
                        BarChartData(
                          barGroups: _buildBarGroups(),
                          titlesData: FlTitlesData(
                            bottomTitles: AxisTitles(
                              sideTitles: SideTitles(
                                showTitles: true,
                                getTitlesWidget: (value, meta) {
                                  switch (value.toInt()) {
                                    case 0:
                                      return const Text('Low');
                                    case 1:
                                      return const Text('Current');
                                    case 2:
                                      return const Text('High');
                                    case 3:
                                      return const Text('Open');
                                    default:
                                      return const Text('');
                                  }
                                },
                              ),
                            ),
                            leftTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: true),
                            ),
                            topTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                            rightTitles: AxisTitles(
                              sideTitles: SideTitles(showTitles: false),
                            ),
                          ),
                          borderData: FlBorderData(show: false),
                        ),
                      ),
                    ),
                    Container(height: 2, color: Colors.black, width: double.infinity),
                  ],
                )
              : const Center(child: Text('Failed to load data')),
    );
  }

  List<BarChartGroupData> _buildBarGroups() {
    final double lowPrice = _stockData!['l'] as double;
    final double currentPrice = _stockData!['c'] as double;
    final double highPrice = _stockData!['h'] as double;
    final double openPrice = _stockData!['o'] as double;

    return [
      BarChartGroupData(
        x: 0,
        barRods: [BarChartRodData(toY: lowPrice, color: Colors.blue)],
      ),
      BarChartGroupData(
        x: 1,
        barRods: [BarChartRodData(toY: currentPrice, color: Colors.green)],
      ),
      BarChartGroupData(
        x: 2,
        barRods: [BarChartRodData(toY: highPrice, color: Colors.red)],
      ),
      BarChartGroupData(
        x: 3,
        barRods: [BarChartRodData(toY: openPrice, color: Colors.orange)],
      ),
    ];
  }
}