import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/app-bar.dart';
import 'package:deplace_maison/layout/footer.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: const AppBarWidget(),
      body: SingleChildScrollView(
        child: Column(children: [child, const Footer()]),
      ),
    );
  }
}
