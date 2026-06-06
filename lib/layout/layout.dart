// layout.dart
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/app-bar.dart';
import 'package:deplace_maison/layout/footer.dart';
import 'package:deplace_maison/layout/side-bar.dart';

class Layout extends StatelessWidget {
  final Widget child;
  const Layout({super.key, required this.child});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFF5F0E8),
      appBar: const AppBarWidget(),
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          const SizedBox(width: 48, child: SideBar()),

          Expanded(
            child: SingleChildScrollView(
              child: Column(children: [child, const Footer()]),
            ),
          ),
        ],
      ),
    );
  }
}
