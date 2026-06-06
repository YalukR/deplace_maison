import 'package:deplace_maison/layout/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/way_archive.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 80);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        WayArchive(),
        Row(
          children: [
            const Expanded(child: SizedBox()),

            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.transparent,
                border: Border.all(color: Colors.black, width: 1),
              ),
              child: const Text(
                'INK MODE',
                style: TextStyle(
                  fontFamily: 'FingerPaint',
                  fontSize: 13,
                  color: Colors.black,
                ),
              ),
            ),

            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: TextWidget(text: 'CART'),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
