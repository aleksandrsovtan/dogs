import 'package:catproject/screens/dogs/dogs_screen.dart';
import 'package:catproject/screens/favorites/favorite_cats_page.dart';
import 'package:catproject/screens/profile.dart/user_profile.dart';
import 'package:flutter/material.dart';

class HomeScreenUser extends StatefulWidget {
  HomeScreenUser({Key? key}) : super(key: key);

  @override
  _HomeScreenUserState createState() => _HomeScreenUserState();
}

class _HomeScreenUserState extends State<HomeScreenUser> {
  int _currentIndex = 0;
  PageController _pageController = PageController();
  List<Widget> _screens = [
    DogsScreen(),
    Favorites(),
    UserProfile(),
  ];
  void _onPageChanged(int index) {}

  void onTapped(int _currentIndex) {
    _pageController.jumpToPage(_currentIndex);
  }

  @override
  Widget build(BuildContext context) => DefaultTabController(
        length: 3,
        child: Scaffold(
          backgroundColor: Colors.orange[100],
          appBar: AppBar(
            title: Text('Cats App'),
            backgroundColor: Colors.orange,
            bottom: TabBar(
              onTap: (index) {
                setState(() {
                  _currentIndex = index;
                  onTapped(_currentIndex);
                });
              },
              indicatorColor: Colors.white,
              tabs: [
                Tab(
                  text: 'Cats',
                ),
                Tab(
                  text: 'Favorites',
                ),
                Tab(
                  text: 'Profile',
                ),
              ],
            ),
          ),
          body: PageView(
            controller: _pageController,
            children: _screens,
            onPageChanged: _onPageChanged,
          ),
        ),
      );
}
