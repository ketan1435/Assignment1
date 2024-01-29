
import 'package:flutter/material.dart';

class HistoryScreen extends StatelessWidget {
  final List<String> history;

  HistoryScreen({required this.history});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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