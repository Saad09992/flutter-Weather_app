import 'package:flutter/material.dart';

class WeatherScreen extends StatelessWidget {
  const WeatherScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Weather App",
          style: TextStyle(
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () => print("refreshed"),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: const Column(
        children: [
          SizedBox(height: 20),
          Placeholder(
            fallbackHeight: 250,
          ),
          SizedBox(height: 20),
          Placeholder(
            fallbackHeight: 150,
          ),
          SizedBox(height: 20),
          Placeholder(
            fallbackHeight: 150,
          )
        ],
      ),
    );
  }
}
