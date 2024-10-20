import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:newway/camera_page.dart';
import 'package:newway/gallery_page.dart';
import 'package:newway/home_page.dart';
import 'package:newway/profile_page.dart';
import 'package:newway/calendar_page.dart'; // Ensure this is the correct path
import 'package:newway/splash_screen.dart';
import 'package:newway/login_page.dart';
import 'package:newway/attendance/attendance_page.dart';
import 'package:newway/leaves/leaves_page.dart';
import 'package:newway/working_site_page.dart';
import 'firebase_options.dart'; // Ensure you have the correct path for firebase_options.dart

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  ); // Initialize Firebase

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'New Way App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => SplashScreen(),
        '/login': (context) => LoginPage(),
        '/home': (context) => BottomNavBar(), // BottomNavBar is the main screen now
        '/camera': (context) => CameraPage(),
        '/gallery': (context) => GalleryPage(), // Added Gallery route
        '/attendance': (context) => AttendancePage(), // Added Attendance route
        '/calendar': (context) => CalendarPage(attendanceList: [],), // Added Calendar route
        '/leaves': (context) => LeavesPage(), // Added Leaves route
        '/working_site': (context) => WorkingSitePage(), // Added Working Site route
      },
    );
  }
}

// BottomNavBar manages the navigation between Home, Attendance, and Profile screens
class BottomNavBar extends StatefulWidget {
  @override
  _BottomNavBarState createState() => _BottomNavBarState();
}

class _BottomNavBarState extends State<BottomNavBar> {
  int _selectedIndex = 0;

  // List of screens to display based on selected index
  final List<Widget> _screens = [
    HomePage(),         // Home screen controls other functionalities
    AttendancePage(),   // Attendance screen
    ProfilePage(),      // Profile screen (if renamed from Business)
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: IndexedStack(
        index: _selectedIndex,
        children: _screens,
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.home),
            label: 'Home',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.assignment_turned_in),
            label: 'Attendance',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: 'Profile', // This was previously Business
          ),
        ],
        currentIndex: _selectedIndex,
        selectedItemColor: Colors.blueAccent,
        onTap: _onItemTapped,
      ),
    );
  }
}
