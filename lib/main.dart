import 'package:deplace_maison/layout/loading.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/app_router.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Déplacé Maison',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, child) => LoadingScreen(child: child!),
    );
  }
}