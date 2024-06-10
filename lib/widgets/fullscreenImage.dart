import 'package:flutter/material.dart';

class FullScreenImage extends StatelessWidget {
  final String imageUrl;

  FullScreenImage({required this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Customize app bar if needed
        title: Text('Full Screen'),
      ),
      body: Center(
        child: Image.network(
          imageUrl,
          fit: BoxFit.cover,
          // You can add more customization to the image widget as needed
        ),
      ),
    );
  }
}
