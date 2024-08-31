import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controllers/auth_controller.dart';

class LoginPage extends StatelessWidget {
  final AuthController authController = Get.find();

  LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Login"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () async {
            await authController.login();
            if (authController.user.value != null) {
              Get.offAllNamed('/home');
            }
          },
          child: const Text("Sign in with Google"),
        ),
      ),
    );
  }
}
