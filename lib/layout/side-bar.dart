import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/text.dart';

class SideBar extends StatelessWidget {
  const SideBar({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: Padding(
            padding: const EdgeInsets.only(left: 14, top: 16),
            child: RotatedBox(
              quarterTurns: 1,
              child: TextWidget(
                text: 'DEPLACE MANSION',
              ),
            ),
          ),
        ),

        Padding(
          padding: const EdgeInsets.only(left: 10, bottom: 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: const [
              TextWidget(text: 'SHOP', fontSize: 11),
              SizedBox(height: 8),
              TextWidget(text: 'COLLECTIONS', fontSize: 11),
              SizedBox(height: 8),
              TextWidget(text: 'ABOUT', fontSize: 11),
            ],
          ),
        ),
      ],
    );
  }
}
