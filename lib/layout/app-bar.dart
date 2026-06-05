import 'package:deplace_maison/layout/widgets/way_archive.dart';
import 'package:flutter/material.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  const AppBarWidget({super.key});

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight + 60);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: const [
        WayArchive(),
        SizedBox(
          height: kToolbarHeight,
          child: Material(
            color: Color(0xFFF5F0E8),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('INK MODE', style: TextStyle(fontSize: 13)),
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 16),
                  child: Text('CART', style: TextStyle(fontSize: 13)),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}