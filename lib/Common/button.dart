import 'package:flutter/material.dart';

class CommonButton extends StatelessWidget {
  String title;
  Color color, textColor;
  VoidCallback onPress;

  CommonButton(this.title, this.color, this.textColor, this.onPress,
      {super.key});

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPress,
      child: Text(
        title,
        style: TextStyle(
          color: textColor,
          fontWeight: FontWeight.w500,
        ),
      ),
      style: ElevatedButton.styleFrom(
          backgroundColor: color,
          minimumSize: Size(MediaQuery.of(context).size.width * 0.7,
              MediaQuery.of(context).size.height * 0.05)),
    );
  }
}
