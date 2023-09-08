import 'package:flutter/material.dart';

class ErrorScreen extends StatelessWidget {
  String error;

  ErrorScreen({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(error),
    );
  }
}
