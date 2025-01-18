import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class ChartScreen extends StatelessWidget {
  const ChartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Grafikler',
      currentIndex: 2,
      body: const Center(
        child: Text(
          'Grafikler Yakında',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
