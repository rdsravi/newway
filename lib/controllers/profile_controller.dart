import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class ProfileController extends GetxController {
  var isLoading = false.obs; // Observable for loading state
  var user = Rx<UserModel?>(null); // Observable for user data

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  @override
  void onInit() {
    super.onInit();
    fetchUserData();
  }

  Future<void> fetchUserData() async {
    isLoading.value = true; // Start loading
    try {
      // Fetch the current user
      User? currentUser = _auth.currentUser;
      if (currentUser != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(currentUser.uid).get();
        if (userDoc.exists) {
          user.value = UserModel.fromFirestore(userDoc.data() as Map<String, dynamic>);
        }
      }
    } catch (e) {
      Get.snackbar("Error", "Failed to load user data");
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Logout method
  void logout(BuildContext context) {
    _showLogoutDialog(context);
  }

  // Show logout confirmation dialog
  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Logout'),
          content: Text('Are you sure you want to logout?'),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(); // Close the dialog
              },
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                // Clear user session (e.g., shared preferences)
                // Example: await SharedPreferences.getInstance().then((prefs) => prefs.clear());
                Navigator.of(context).pop(); // Close the dialog
                _logout();
              },
              child: Text('Logout'),
            ),
          ],
        );
      },
    );
  }

  // Perform the logout action
  void _logout() {
    _auth.signOut();
    // Navigate back to the login screen after logout
    Get.offAllNamed('/login');
  }

  // Function to update user notifications in Firestore
  Future<void> updateNotifications(bool value) async {
    final UserModel user = this.user.value!;
    user.notificationsEnabled = value;

    try {
      await _firestore.collection('users').doc(user.uid).update({
        'notificationsEnabled': value,
      });
    } catch (e) {
      Get.snackbar("Error", "Failed to update notifications setting");
    }
  }
}

// User model to handle data
class UserModel {
  String? uid;
  String? email;
  String? name;
  String? mobileNumber;
  String? gender;
  bool? notificationsEnabled;
  String? profilePictureUrl;

  UserModel({
    this.uid,
    this.email,
    this.name,
    this.mobileNumber,
    this.gender,
    this.notificationsEnabled,
    this.profilePictureUrl,
  });

  // Factory constructor to create a UserModel from Firestore data
  factory UserModel.fromFirestore(Map<String, dynamic> data) {
    return UserModel(
      uid: data['uid'],
      email: data['email'],
      name: data['name'],
      mobileNumber: data['mobileNumber'],
      gender: data['gender'],
      notificationsEnabled: data['notificationsEnabled'] ?? true,
      profilePictureUrl: data['profilePictureUrl'] ?? '',
    );
  }

  // Convert UserModel to Firestore data
  Map<String, dynamic> toFirestore() {
    return {
      'uid': uid,
      'email': email,
      'name': name,
      'mobileNumber': mobileNumber,
      'gender': gender,
      'notificationsEnabled': notificationsEnabled,
      'profilePictureUrl': profilePictureUrl,
    };
  }
}
