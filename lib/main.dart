import 'package:deplace_maison/layout/loading.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/app_router.dart';

void main() => runApp(const MyApp());

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      title: 'Déplacé Maison',
      debugShowCheckedModeBanner: false,
      routerConfig: appRouter,
      builder: (context, child) => _Shell(child: child!),
    );
  }
}

class _Shell extends StatefulWidget {
  final Widget child;
  const _Shell({required this.child});

  @override
  State<_Shell> createState() => _ShellState();
}

class _ShellState extends State<_Shell> {
  bool _ready = false;

  @override
  Widget build(BuildContext context) {
    return LoadingScreen(
      onComplete: () => setState(() => _ready = true),
      child: _ready ? widget.child : const SizedBox.shrink(),
    );
  }
}
