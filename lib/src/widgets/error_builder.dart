import 'package:flutter/material.dart';

class ErrorBuilder extends StatelessWidget {
  final String error;
  final VoidCallback onTap;

  const ErrorBuilder({Key? key, required this.error, required this.onTap}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(error, textAlign: TextAlign.center),

        const SizedBox(height: 5.0),

        ElevatedButton(
          onPressed: onTap, 
          style: ElevatedButton.styleFrom(),
          child: const Text('Intentar de nuevo')
        )
      ],
    );
  }
}