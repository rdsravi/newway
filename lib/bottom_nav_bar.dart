import 'package:flutter/material.dart';
import 'package:newway/profile/profile_page.dart';

import 'attendance/attendance_page.dart';
import 'home_page.dart';

class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> with SingleTickerProviderStateMixin {
  int _selectedIndex = 0;
  late AnimationController _animationController;
  late CurvedAnimation _curvedAnimation;

  // List of screens
  final List<Widget> _screens = [
    HomePage(),
    AttendancePage(),
    ProfilePage(),
  ];

  // List of icons for bottom navigation bar
  final List<IconData> iconList = [
    Icons.home,
    Icons.assignment_turned_in,
    Icons.person,
  ];

  @override
  void initState() {
    super.initState();

    // Initialize animation controller for smooth transitions
    _animationController = AnimationController(
      duration: Duration(milliseconds: 500),
      vsync: this,
    );

    _curvedAnimation = CurvedAnimation(
      parent: _animationController,
      curve: Curves.easeInOut,
    );

    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });

    // Start the animation when the tab is selected
    _animationController.reset();
    _animationController.forward();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        unselectedItemColor: Colors.grey,
        onTap: _onItemTapped,
        items: [
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(0),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(1),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: _buildAnimatedIcon(2),
            label: 'Profile',
          ),
        ],
      ),
    );
  }

  // This method creates animated icons with transitions
  Widget _buildAnimatedIcon(int index) {
    return AnimatedBuilder(
      animation: _curvedAnimation,
      builder: (context, child) {
        double iconSize = _selectedIndex == index ? 36 : 24;  // Scale the selected icon size
        Color iconColor = _selectedIndex == index ? Colors.blueAccent : Colors.grey; // Change color based on selection
        return Icon(
          iconList[index],
          size: iconSize,
          color: iconColor,
        );
      },
    );
  }
}
