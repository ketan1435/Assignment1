import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'history_screen.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String imageUrl = '';
  List<String> history = [];
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
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
                      builder: (context) => HistoryScreen(history: history),
                    ),
                  );
                },
                child: Text('View History'),
              ),
            ],
          ),
        ),
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
