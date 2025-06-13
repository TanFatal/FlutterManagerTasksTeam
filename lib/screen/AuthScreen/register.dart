import 'dart:math';

import 'package:flutter/material.dart';
import 'package:testflutter/Widget/auth/ButtonWidget.dart';
import 'package:testflutter/Widget/auth/FieldWidget.dart';
import 'package:testflutter/screen/AuthScreen/login.dart';
import 'package:testflutter/services/auth_api_service.dart';
import 'package:testflutter/utils/validators.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  void _handleRegister() async {
    if (_formKey.currentState!.validate()) {
      String response = await AuthApiService().signUp(
        _emailController.text,
        _passwordController.text,
        _nameController.text,
      );
      if (response == "access") {
        showDialog(
            context: context,
            barrierDismissible: false, // không cho bấm ra ngoài
            builder: (context) => AlertDialog(
                  title: const Text('Email verification'),
                  content: Text(
                    "Email has been sent to ${_emailController.text} for verification.\nPlease confirm to complete registration.",
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // đóng dialog
                        Navigator.of(context).pushReplacement(
                          MaterialPageRoute(
                              builder: (_) => const LoginScreen()),
                        );
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ));
      } else {
        showDialog(
            context: context,
            barrierDismissible: false, // không cho bấm ra ngoài
            builder: (context) => AlertDialog(
                  title: const Text('Email verification'),
                  content: Text(response),
                  actions: [
                    TextButton(
                      onPressed: () {
                        Navigator.of(context).pop(); // đóng dialog
                      },
                      child: const Text("OK"),
                    ),
                  ],
                ));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields correctly')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(40, 40, 40, 0),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 50),
                Center(
                  child: Container(
                    width: 90, // Chiều rộng của container
                    height: 90, // Chiều cao của container
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(30), // Bo tròn
                      image: DecorationImage(
                        image: AssetImage('assets/logo.png'),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                ),
                const Text(
                  "Rup Rup",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 32,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Text(
                  "Promote the spirit of Teamwork",
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontSize: 14,
                      color: Colors.grey,
                      fontWeight: FontWeight.bold),
                ),
                const SizedBox(height: 25),
                const Text(
                  "Sign up",
                  textAlign: TextAlign.left,
                  style: TextStyle(
                    fontSize: 22,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 10),
                const Text(
                  "Enter your credentials to continue",
                  style: TextStyle(
                    fontSize: 17,
                    color: Colors.grey,
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _emailController,
                  validator: (value) {
                    // add email validation
                    if (value == null || value.isEmpty) {
                      return 'Please enter Your Email';
                    }
                    bool emailValid = RegExp(
                      r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+",
                    ).hasMatch(value);
                    if (!emailValid) {
                      return 'Please enter a valid email';
                    }
                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Email',
                    hintText: 'Enter your Email',
                    prefixIcon: Icon(Icons.email_outlined),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _passwordController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập mật khẩu';
                    }

                    if (value.length < 8) {
                      return 'Mật khẩu phải có ít nhất 8 ký tự';
                    }

                    if (!RegExp(r'[A-Z]').hasMatch(value)) {
                      return 'Mật khẩu phải có ít nhất một chữ hoa (A-Z)';
                    }

                    if (!RegExp(r'[a-z]').hasMatch(value)) {
                      return 'Mật khẩu phải có ít nhất một chữ thường (a-z)';
                    }

                    if (!RegExp(r'[0-9]').hasMatch(value)) {
                      return 'Mật khẩu phải có ít nhất một chữ số (0-9)';
                    }

                    if (!RegExp(r'[!@#$%^&*(),.?":{}|<>]').hasMatch(value)) {
                      return 'Mật khẩu phải có ít nhất một ký tự đặc biệt (!@#\$%^&*...)';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Password',
                    hintText: 'Enter your Password',
                    prefixIcon: Icon(Icons.lock_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _nameController,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Vui lòng nhập full name';
                    }

                    return null;
                  },
                  decoration: const InputDecoration(
                    labelText: 'Full Name',
                    hintText: 'Enter your Full Name',
                    prefixIcon: Icon(Icons.person_outline),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 30),
                ButtonWidget(nameButton: "Sign up", onTap: _handleRegister),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text("Already have an account? "),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pushAndRemoveUntil(
                        MaterialPageRoute(builder: (_) => const LoginScreen()),
                        (Route<dynamic> route) => false,
                      ),
                      child: const Text(
                        "Log in",
                        style: TextStyle(
                          color: Colors.blue,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
