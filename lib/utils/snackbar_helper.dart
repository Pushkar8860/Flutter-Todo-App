import 'package:flutter/material.dart';

void showMessage(BuildContext context, String message, bool type) {
  final snackBar = SnackBar(
      content: Text(message),
      backgroundColor: type ? Colors.red : Colors.green);
  ScaffoldMessenger.of(context).showSnackBar(snackBar);
}