import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:firebase_auth/firebase_auth.dart';

class LoginController extends GetxController {
  // State variables
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  var isLoading = false.obs; // observable for loading state
  var errorMessage = ''.obs; // observable for error message

  // Firebase Auth instance
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Method to handle login
  Future<void> login() async {
    isLoading.value = true; // Start loading
    errorMessage.value = ''; // Reset error message

    try {
      // Sign in with Firebase
      await _auth.signInWithEmailAndPassword(
        email: emailController.text.trim(),
        password: passwordController.text.trim(),
      );
      Get.offAllNamed('/home'); // Navigate to home on success
    } on FirebaseAuthException catch (e) {
      errorMessage.value = e.message!;
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
