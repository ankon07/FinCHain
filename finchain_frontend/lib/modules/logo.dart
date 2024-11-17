import 'package:flutter/material.dart';

class Logo extends StatelessWidget {
  final double size;

  const Logo({super.key, required this.size});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          color: Colors.white, // White background for the logo
          padding:
              const EdgeInsets.all(8.0), // Optional padding for better look
          child: Image.asset(
            'assets/images/finchain.png', // Replace with actual logo path
            height: size,
            width: size,
            fit: BoxFit.contain,
          ),
        ),
        const SizedBox(height: 8), // Space between logo and text
        const Text(
          'Finchain',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Colors.white, // Black text for contrast
          ),
        ),
      ],
    );
  }
}
