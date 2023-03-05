// ignore_for_file: use_key_in_widget_constructors

import 'package:flutter/material.dart';

//custom icon display widget
class MyIcon extends StatelessWidget {
  final String letter;

  const MyIcon({required this.letter});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 50,
      height: 50,
      decoration: const BoxDecoration(
        color: Colors.blue,
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Text(
          letter,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
            fontSize: 20,
          ),
        ),
      ),
    );
  }
}
