import 'package:deplace_maison/layout/widgets/arrows.dart';
import 'package:flutter/material.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return SizedBox(
      width: size.width,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Padding(
            padding: const EdgeInsets.only(left: 60, top: 24, right: 24),
            child: RichText(
              textAlign: TextAlign.right,
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
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/first/man.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '(01)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'HedvigLettersSans',
                                ),
                              ),
                              Text(
                                'MAN',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'HedvigLettersSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Image.asset(
                            'assets/images/first/wmn.png',
                            fit: BoxFit.cover,
                          ),
                          const SizedBox(height: 8),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: const [
                              Text(
                                '(02)',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'HedvigLettersSans',
                                ),
                              ),
                              Text(
                                'WMNS',
                                style: TextStyle(
                                  fontSize: 11,
                                  fontFamily: 'HedvigLettersSans',
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),

                const SizedBox(height: 32),
                const Divider(color: Colors.black, thickness: 0.5),
                const SizedBox(height: 24),

                Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    ArrowsWidget(
                      label: 'EXPLORE',
                      direction: ArrowDirection.right,
                    ),
                  ],
                ),

                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
