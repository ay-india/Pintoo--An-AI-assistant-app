import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Hint extends StatelessWidget {
  final String hintText;
  final Color hintColor;
  const Hint({super.key, required this.hintColor, required this.hintText});

  @override
  Widget build(BuildContext context) {
    return Container(
      // height: 30,
      margin: const EdgeInsets.symmetric(
        // horizontal: 30,
        vertical: 8,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(10),
        color: hintColor,
      ),
      child: Text(
        hintText,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
        style: TextStyle(fontSize: 15),
      ),
    );
  }
}
