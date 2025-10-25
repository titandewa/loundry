import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  int _currentIndex = 0;

  final List<IconData> _icons = [
    Icons.home_rounded,
    Icons.shopping_bag_rounded,
    Icons.person_rounded,
  ];

  final List<String> _labels = ['Beranda', 'Pesanan', 'Profil'];

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: _currentIndex,
      selectedItemColor: Colors.blueAccent,
      unselectedItemColor: Colors.grey,
      onTap: (index) {
        setState(() {
          _currentIndex = index;
        });
      },
      items: List.generate(
        _icons.length,
        (index) => BottomNavigationBarItem(
          icon: Icon(_icons[index]),
          label: _labels[index],
        ),
      ),
    );
  }
}
