import 'package:flutter/material.dart';
import 'package:seller_information_v2/screens/chart_screen.dart';
import 'package:seller_information_v2/screens/profile_screen.dart';
import 'package:seller_information_v2/screens/seller_list_screen.dart';
import '../widgets/app_layout.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return AppLayout(
      title: 'Ana Sayfa',
      currentIndex: 0,
      body: Container(
        decoration: const BoxDecoration(
          color: Color(0xFFF5F5F5),
        ),
        child: Padding(
          padding: const EdgeInsets.all(20.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Hoş Geldiniz',
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Color(0xFF333333),
                ),
              ),
              const SizedBox(height: 20),
              const Text(
                'Hızlı Erişim',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(height: 20),
              Expanded(
                child: _buttonGridView(context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  GridView _buttonGridView(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      crossAxisSpacing: 20,
      mainAxisSpacing: 20,
      scrollDirection: Axis.vertical,
      children: [
        _buildGridButton(
          context,
          'Mağaza Listesi',
          Icons.list,
          Colors.purple.shade400,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const SellerListScreen()),
            );
          },
        ),
        _buildGridButton(
          context,
          'Grafikler',
          Icons.bar_chart,
          Colors.orange.shade400,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ChartScreen()),
            );
          },
        ),
        _buildGridButton(
          context,
          'Profil',
          Icons.person,
          Colors.blue.shade400,
          () {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => const ProfileScreen()),
            );
          },
        ),
      ],
    );
  }

  Widget _buildGridButton(
    BuildContext context,
    String title,
    IconData icon,
    Color color,
    VoidCallback onPressed,
  ) {
    return Material(
      elevation: 4,
      borderRadius: BorderRadius.circular(20),
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(20),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  // ignore: deprecated_member_use
                  color: color.withOpacity(0.1),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, size: 32, color: color),
              ),
              const SizedBox(height: 12),
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
