import 'package:flutter/material.dart';

class SquareButton extends StatelessWidget {
  final String text;
  final double size;
  final VoidCallback onPressed;

  const SquareButton({
    required this.text,
    required this.size,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      child: Text(
        text,
        style: TextStyle(
          color: Colors.white, // Text color white
          fontSize: 20.0,
          fontWeight: FontWeight.bold,
        ),
      ),
      style: ElevatedButton.styleFrom(
        backgroundColor: Color.fromRGBO(237, 42, 110, 1), // Button color
        padding: EdgeInsets.symmetric(
          vertical: 15.0, // Adjust padding based on size
          horizontal: size, // Fixed horizontal padding
        ),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8.0), // Rectangle shape
        ),
      ),
    );
  }
}
