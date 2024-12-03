import 'package:flutter/material.dart';
import 'package:stockapp/home.dart';
import 'package:stockapp/watchlist.dart';


class NewsFeed extends StatefulWidget {
  const NewsFeed({super.key});

  @override
  _NewsFeedState createState() => _NewsFeedState();
}

class _NewsFeedState extends State<NewsFeed> {

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
      body: Column(
        children: [
          const SizedBox(width: 50),
          const SizedBox(height: 20),
          const Text(
            "Welcome!",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 10),
          const Text(
            "This is your total spending summary",
            style: TextStyle(fontSize: 16, color: Colors.grey),
            textAlign: TextAlign.center,
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => const LogOut()));
            },
            child: const Icon(Icons.edit),
          ),
          const SizedBox(height: 5),
          const SizedBox(height: 10),
        const Spacer(),
        Container(height: 2, color: Colors.black, width: double.infinity),
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