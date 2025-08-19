import 'package:easytrek/Screens/MapPage.dart';
import 'package:easytrek/Screens/SocialCommunity.dart';
import 'package:easytrek/Screens/profileScreen.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../main.dart';
import '../provider/authServiceProvider.dart';
import '../provider/navigationProvider.dart';
import 'Chat_Page.dart';
import 'HomePage.dart';
import 'MarketPage.dart';
import 'mybookingScreen.dart';

class MainScreen extends StatelessWidget {
  const MainScreen({super.key});

  static final List<Widget> _pages = <Widget>[
    const HomePage(),
    const CommunityPage(),
    MyBookingsScreen(),
    const MapPage(),
    const MarketPage(),
    const FriendsListTab(),
  ];

  static const List<String> _pageTitles = [
    'Treks',
    'Community',
    'My Bookings',
    'Map',
    'Market',
    'Chat',
  ];

  @override
  Widget build(BuildContext context) {
    final navProvider = Provider.of<NavigationProvider>(context);
    final authService = Provider.of<AuthService>(context, listen: false);
    final bool showAppBarTitle = navProvider.selectedIndex != 4;

    return Scaffold(
      appBar: AppBar(
        elevation: showAppBarTitle ? 0 : 0,
        scrolledUnderElevation: 0,
        backgroundColor: showAppBarTitle ? AppTheme.background : Colors.white,
        centerTitle: true,
        title: showAppBarTitle ? Text(_pageTitles[navProvider.selectedIndex]) : null,
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 12.0),
            child: GestureDetector(
              onTap: () {
                Navigator.of(context).push(
                  MaterialPageRoute(builder: (_) => const ProfileScreen()),
                );
              },
              child: CircleAvatar(
                radius: 18,
                backgroundColor: AppTheme.primary,
                child: Text(
                  authService.user?.email?.substring(0, 1).toUpperCase() ?? 'U',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
      body: _pages.elementAt(navProvider.selectedIndex),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: navProvider.selectedIndex,
        onTap: (index) => navProvider.setIndex(index),
        selectedItemColor: AppTheme.primary,
        unselectedItemColor: Colors.grey,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home_outlined),
            activeIcon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.people_outline),
            activeIcon: Icon(Icons.people),
            label: 'Community',
          ),BottomNavigationBarItem(
            icon: Icon(Icons.bookmark_outline),
            activeIcon: Icon(Icons.bookmark),
            label: 'My Bookings',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.map_outlined),
            activeIcon: Icon(Icons.map),
            label: 'Map',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.store_outlined),
            activeIcon: Icon(Icons.store),
            label: 'Market',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.chat_bubble_outline),
            activeIcon: Icon(Icons.chat_bubble),
            label: 'Chat',
          ),
        ],
      ),
    );
  }
}