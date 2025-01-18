import 'package:flutter/material.dart';
import '../widgets/app_layout.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Profil',
      currentIndex: 3,
      body: const Center(
        child: Text(
          'Profil Yakında',
          style: TextStyle(fontSize: 24),
        ),
      ),
    );
  }
}
