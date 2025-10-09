import 'package:flutter/material.dart';

class AppEntryPoint extends StatelessWidget {
  const AppEntryPoint({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Just some text, that neeeds to change'),
        backgroundColor: Colors.green,
        foregroundColor: Colors.white,
      ),

      // Sets the content to the
      // center of the application page
      body: const Center(
        // Sets the content of the Application
        child: Text('Welcome to Android Studio!'),
      ),
    );
  }
}
