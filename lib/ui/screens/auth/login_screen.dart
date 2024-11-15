import 'dart:ui';

import 'package:app/constants/ui.dart';
import 'package:app/providers/state.dart';
import 'package:app/services/auth_service.dart';
import 'package:app/services/prefs_service.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final error = "".obs;
  final loading = false.obs;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: UIConstants.backgroundColor,
      body: Stack(
        children: [
          Positioned(
              left: -220,
              bottom: -200,
              child: Container(
                width: 400,
                height: 400,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: const Color(0xff8369de).withOpacity(0.1),
                    boxShadow: const [
                      BoxShadow(
                        color: Color(0xff8369de),
                        spreadRadius: 90,
                        blurRadius: 100,
                      )
                    ]),
              )),
          Positioned(
              top: 130,
              left: 220,
              child: Container(
                width: 300,
                height: 300,
                decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(colors: [
                      Color(0xff744ff9),
                      Color(0xff8369de),
                      Color(0xff8da0cb)
                    ])),
              )),
          Positioned(
              bottom: 250,
              right: 150,
              child: Transform.rotate(
                angle: 8,
                child: Container(
                  width: 180,
                  height: 180,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle,
                      gradient: LinearGradient(colors: [
                        Color(0xff744ff9),
                        Color(0xff8369de),
                        Color(0xff8da0cb)
                      ])),
                ),
              )),
          Center(
            child: ClipRRect(
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 30, sigmaY: 30),
                child: Container(
                  padding: const EdgeInsets.all(40),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.2),
                  ),
                  width: double.infinity,
                  height: double.infinity,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Center(
                        child: Text(
                          "login".tr,
                          style: const TextStyle(
                            fontSize: 40,
                            fontWeight: FontWeight.bold,
                            color: Colors.white,
                          ),
                        ),
                      ),
                      const SizedBox(height: 40),
                      TextField(
                        controller: _emailController,
                        decoration: InputDecoration(
                          hintText: "email".tr,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        keyboardType: TextInputType.emailAddress,
                      ),
                      const SizedBox(height: 20),
                      TextField(
                        controller: _passwordController,
                        decoration: InputDecoration(
                          hintText: "password".tr,
                          hintStyle:
                              TextStyle(color: Colors.grey[400], fontSize: 20),
                          filled: true,
                          fillColor: Colors.white.withOpacity(0.1),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none,
                          ),
                        ),
                        style:
                            const TextStyle(color: Colors.white, fontSize: 20),
                        obscureText: true,
                      ),
                      const SizedBox(height: 30),
                      Obx(
                        () => Center(
                          child: Text(
                            error.value,
                            style: const TextStyle(
                              color: Colors.red,
                              fontSize: 18,
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 15),
                      Center(
                        child: Obx(
                          () => ElevatedButton(
                            onPressed: loading.value
                                ? null
                                : () {
                                    loading.value = true;
                                    error.value = "";
                                    AuthService()
                                        .login(
                                      _emailController.text,
                                      _passwordController.text,
                                    )
                                        .then((value) {
                                      AppPrefs.setToken(value.token);
                                      AppState.user.value = value.user;
                                      loading.value = false;
                                      error.value = "";
                                      Get.toNamed("/homee");
                                    }).catchError(
                                      (e) {
                                        if (e is DioException) {
                                          error.value =
                                              e.response!.data['error'];
                                        }
                                        loading.value = false;
                                      },
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color(0xff744ff9),
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 100, vertical: 20),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                            ),
                            child: loading.value
                                ? const CircularProgressIndicator()
                                : Text(
                                    "login".tr,
                                    style: const TextStyle(
                                      fontSize: 20,
                                      color: Colors.white,
                                    ),
                                  ),
                          ),
                        ),
                      ),
                      const SizedBox(height: 25),
                      // Center(
                      //   child: TextButton(
                      //     onPressed: () {
                      //       // Add reset password logic here
                      //     },
                      //     child: const Text(
                      //       "Forgot Password?",
                      //       style:
                      //           TextStyle(color: Colors.white70, fontSize: 18),
                      //     ),
                      //   ),
                      // ),
                      const Divider(color: Colors.white24),
                      Center(
                        child: TextButton(
                          onPressed: () {
                            Get.toNamed('/register');
                          },
                          child: Text(
                            "new_acc".tr,
                            style: const TextStyle(
                                color: Colors.white, fontSize: 18),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
