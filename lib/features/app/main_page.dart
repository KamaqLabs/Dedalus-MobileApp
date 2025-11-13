import 'package:dedalus/core/theme/color_palette.dart';
import 'package:flutter/material.dart';
import 'package:dedalus/features/discover/presentation/pages/discover_page.dart';
import 'package:dedalus/features/favorites/presentation/pages/favorites_page.dart';
import 'package:dedalus/features/bookings/presentation/pages/bookings_page.dart';
import 'package:dedalus/features/profile/presentation/pages/profile_page.dart';

class MainPage extends StatefulWidget {
  final String userName;
  const MainPage({super.key, required this.userName});

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  int _selectedIndex = 0;

  late final List<Widget> _pages;

  @override
  void initState() {
    super.initState();
    _pages = [
      DiscoverPage(userName: widget.userName),
      const FavoritesPage(),
      const BookingsPage(),
      const ProfilePage(), 
    ];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _pages[_selectedIndex]),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        onTap: (value) {
          setState(() {
            _selectedIndex = value;
          });
        },
        selectedItemColor: ColorPalette.primaryColor,
        type: BottomNavigationBarType.fixed,
        items: [
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.explore),
              icon: Icon(Icons.explore_outlined),
              label: 'Discover'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.favorite),
              icon: Icon(Icons.favorite_outlined),
              label: 'Favorites'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.book),
              icon: Icon(
                Icons.book_outlined,
              ),
              label: 'Bookings'),
          BottomNavigationBarItem(
              activeIcon: Icon(Icons.person),
              icon: Icon(Icons.person_outlined),
              label: 'Profile'),
        ],
      ),
    );
  }
}
