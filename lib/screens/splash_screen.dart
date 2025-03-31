import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // App logo
            Icon(
              Icons.note_alt_outlined,
              size: 80,
              color: Theme.of(context).primaryColor,
            ),
            const SizedBox(height: 24),
            // App name
            Text(
              'Notes App',
              style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                fontWeight: FontWeight.bold,
                color: Theme.of(context).primaryColor,
              ),
            ),
            const SizedBox(height: 48),
            // Loading indicator
            const CircularProgressIndicator(),
          ],
        ),
      ),
    );
  }
}
