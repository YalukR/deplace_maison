import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, top: 24, right: 24),
            child: RichText(
              text: TextSpan(
                style: TextStyle(
                  fontFamily: 'HedvigLettersSans',
                  color: Colors.black,
                  fontWeight: FontWeight.w900,
                  height: 0.85,
                ),
                children: [
                  TextSpan(
                    text: 'SPRING,\n',
                    style: TextStyle(fontSize: size.width * 0.13),
                  ),
                  TextSpan(
                    text: 'SUMMER',
                    style: TextStyle(fontSize: size.width * 0.13),
                  ),
                  TextSpan(
                    text: '  COLL.\n        2021',
                    style: TextStyle(fontSize: size.width * 0.04),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 32),

          Padding(
            padding: const EdgeInsets.only(left: 60, right: 24),
            child: Row(
              children: [
                Expanded(
                  child: Image.asset(
                    'assets/images/first/man.png',
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Image.asset(
                    'assets/images/first/wmn.png',
                    fit: BoxFit.cover,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
