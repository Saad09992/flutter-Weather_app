import 'package:flutter/material.dart';

class HourlyCards extends StatelessWidget {
  final String time;
  final IconData icon;
  final String temp;
  const HourlyCards(
      {super.key, required this.icon, required this.temp, required this.time});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 120,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Card(
          elevation: 6,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Text(
                  time,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                const SizedBox(
                  height: 8,
                ),
                Icon(
                  icon,
                  size: 30,
                ),
                const SizedBox(
                  height: 8,
                ),
                Text(
                  temp,
                  style: const TextStyle(fontWeight: FontWeight.w600),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
