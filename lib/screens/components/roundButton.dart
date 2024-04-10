import 'package:flutter/material.dart';

class RoundButton extends StatelessWidget {
  final String text;
  final VoidCallback onClick;
  final double width; // New parameter to accept width

  const RoundButton({
    required this.text,
    required this.onClick,
    required this.width, // Initialize width parameter
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Builder(
      builder: (BuildContext context) {
        return Center(
          child: InkWell(
            onTap: onClick,
            child: Container(
              height: 60,
              width: width, // Set width from parameter
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(30),
                color: const Color.fromRGBO(
                  237,
                  42,
                  110,
                  1,
                ),
              ),
              child: Center(
                child: Text(
                  text,
                  style: TextStyle(
                    fontSize: 25,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}
