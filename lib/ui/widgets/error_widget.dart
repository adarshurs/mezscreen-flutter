import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ErrorCustomWidget extends StatelessWidget {
  final String errorText;
  const ErrorCustomWidget({super.key, required this.errorText});

  @override
  Widget build(BuildContext context) {
    return Column(children: [
      const Icon(
        Icons.error_outline,
        color: Colors.red,
        size: 60,
      ),
      Padding(
        padding: const EdgeInsets.only(top: 16),
        child: Text('Error: $errorText'),
      )
    ]);
  }
}
