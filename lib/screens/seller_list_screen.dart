import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class SellerListScreen extends StatelessWidget {
  const SellerListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Mağaza Listesi',
      currentIndex: 1,
      body: const Center(
        child: Text(
          'Mağaza Listesi Yakında',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
