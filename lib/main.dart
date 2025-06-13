import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:testflutter/Splash.dart';
import 'package:testflutter/models/UserSession.dart';
import 'package:testflutter/models/user.dart';
import 'package:testflutter/screen/AuthScreen/login.dart';
import 'package:testflutter/services/dio_service.dart';
import 'package:testflutter/services/storage/ApiService.dart';
import 'package:testflutter/services/storage/storage_service.dart';
import 'dart:convert';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const SplashScreen(),
    );
  }
}
