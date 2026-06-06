import 'package:deplace_maison/layout/widgets/text.dart';
import 'package:flutter/material.dart';
import 'package:deplace_maison/layout/widgets/way_archive.dart';

class AppBarWidget extends StatelessWidget implements PreferredSizeWidget {
  final bool showInkBar;
  const AppBarWidget({super.key, this.showInkBar = true});

  @override
  Size get preferredSize =>
      Size.fromHeight(showInkBar ? kToolbarHeight + 80 : 80);

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      elevation: 0,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          WayArchive(),
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            curve: Curves.easeInOut,
            height: showInkBar ? kToolbarHeight : 0,
            child: SingleChildScrollView(
              physics: const NeverScrollableScrollPhysics(),
              child: SizedBox(
                height: kToolbarHeight,
                child: Row(
                  children: [
                    const Expanded(child: SizedBox()),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
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
              ),
            ),
          ),
        ],
      ),
    );
  }
}
