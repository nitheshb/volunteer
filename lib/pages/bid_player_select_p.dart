import 'package:flutter/material.dart';

class BidPlayerSelectP extends StatelessWidget {
  final String text;
  // receive data from the FirstScreen as a parameter
  BidPlayerSelectP({Key key, @required this.text}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('bid screen')),
      body: Center(
        child: Text(
          text,
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}