import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class LoginController extends GetxController {
  // State variables
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs; // Observable for loading state
  var errorMessage = ''.obs; // Observable for error message
  var isPasswordVisible = false.obs; // Observable for password visibility
  var userData = {}.obs; // Observable for user data

  // Firebase Auth and Firestore instances
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  // Regex for email validation
  final emailRegex = RegExp(r'^[^@]+@[^@]+\.[^@]+');

  // Method to handle login
  Future<void> login() async {
    isLoading.value = true; // Start loading
    errorMessage.value = ''; // Reset error message

    String email = emailController.text.trim();
    String password = passwordController.text.trim();

    // Check for empty fields
    if (email.isEmpty || password.isEmpty) {
      _showAlert("Please fill out all fields");
      isLoading.value = false; // Stop loading
      return;
    }

    // Validate email format
    if (!emailRegex.hasMatch(email)) {
      _showAlert("Please enter a valid email address");
      isLoading.value = false; // Stop loading
      return;
    }

    // Check if password is at least 6 characters
    if (password.length < 6) {
      _showAlert("Password must be at least 6 characters long");
      isLoading.value = false; // Stop loading
      return;
    }

    // Proceed with login if all validations pass
    try {
      // Sign in with Firebase
      UserCredential userCredential = await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );

      // Fetch user data from Firestore
      User? user = userCredential.user;
      if (user != null) {
        DocumentSnapshot userDoc = await _firestore.collection('users').doc(user.uid).get();

        if (userDoc.exists) {
          // Store user data in observable
          userData.value = userDoc.data() as Map<String, dynamic>;

          // Navigate to the home page
          Get.offAllNamed('/home');
        } else {
          // Create new user data if not found
          await _firestore.collection('users').doc(user.uid).set({
            'email': user.email,
            'createdAt': Timestamp.now(),
            'name': '', // Add default fields
            'phone': '',
          });

          // Fetch the newly created data
          DocumentSnapshot newUserDoc = await _firestore.collection('users').doc(user.uid).get();
          userData.value = newUserDoc.data() as Map<String, dynamic>;

          Get.offAllNamed('/home');
        }
      }
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message ?? "Login failed. Please try again.";
      _showAlert(errorMessage.value);
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  // Function to toggle password visibility
  void togglePasswordVisibility() {
    isPasswordVisible.value = !isPasswordVisible.value;
  }

  // Function to show alert messages
  void _showAlert(String message) {
    Get.snackbar(
      "Error",
      message,
      snackPosition: SnackPosition.BOTTOM,
      backgroundColor: Colors.redAccent,
      colorText: Colors.white,
    );
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
