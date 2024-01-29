import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  runApp(MyApp());
}
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Dog App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: HomePage(),
    );
  }
}

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  String imageUrl = '';
  List<String> history = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog App - Home'),
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          imageUrl.isEmpty
              ? CircularProgressIndicator()
              : Image.network(imageUrl),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: _fetchImage,
            child: Text('Fetch New Image'),
          ),
          SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => HistoryPage(history: history),
                ),
              );
            },
            child: Text('View History'),
          ),
        ],
      ),
    );
  }

  Future<void> _fetchImage() async {
    final response = await http.get(Uri.parse('https://dog.ceo/api/breeds/image/random'));
    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      final newImageUrl = data['message'];
      setState(() {
        imageUrl = newImageUrl;
        history.add(newImageUrl);
      });
      _saveHistoryToLocal();
    } else {
      print('Failed to fetch image. Error ${response.statusCode}');
    }
  }

  Future<void> _saveHistoryToLocal() async {
    final prefs = await SharedPreferences.getInstance();
    prefs.setStringList('history', history);
  }
}

class HistoryPage extends StatelessWidget {
  final List<String> history;

  HistoryPage({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dog App - History'),
      ),
      body: ListView.builder(
        itemCount: history.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Image.network(history[index]),
          );
        },
      ),
    );
  }
}
