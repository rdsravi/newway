import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:newway/controllers/login_controller.dart';

class LoginPage extends StatelessWidget {
  final LoginController loginController = Get.put(LoginController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Login')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextField(
              controller: loginController.emailController,
              decoration: InputDecoration(labelText: 'Email'),
            ),
            TextField(
              controller: loginController.passwordController,
              decoration: InputDecoration(labelText: 'Password'),
              obscureText: true,
            ),
            SizedBox(height: 20),
            Obx(() => loginController.isLoading.value
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: loginController.login, // Trigger login
              child: Text('Login'),
            )),
            SizedBox(height: 20),
            Obx(() => loginController.errorMessage.isNotEmpty
                ? Text(
              loginController.errorMessage.value,
              style: TextStyle(color: Colors.red),
            )
                : Container()),
          ],
        ),
      ),
    );
  }
}
