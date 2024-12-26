import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:newway/attendance/attendance_page.dart';
import 'package:newway/calendar_page.dart';
import 'package:newway/camera_page.dart';
import 'package:newway/gallery_page.dart';
import 'package:newway/leaves/leaves_page.dart';
import 'firebase_options.dart';
import 'package:newway/splash_screen.dart';
import 'package:newway/login/login_page.dart';
import 'package:newway/bottom_navbar.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'New Way App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: '/',
      getPages: [
        GetPage(name: '/', page: () => SplashScreen()),
        GetPage(name: '/login', page: () => LoginPage()),
        GetPage(name: '/home', page: () => BottomNavBar()),
        GetPage(name: '/camera', page: () => CameraPage()),
        GetPage(name: '/attendance', page: () => AttendancePage()),
        GetPage(name: '/calendar', page: () => CalendarPage(attendanceList: [],)),
        GetPage(name: '/gallery', page: () => GalleryPage()),
        GetPage(name: '/leaves', page: () => LeavesPage()),
      ],
    );
  }
}
