import 'package:deplace_maison/layout/widgets/arrows.dart';
import 'package:flutter/material.dart';

class CatalogItem {
  final String name;
  final String image;
  final String season;
  final double originalPrice;
  final double salePrice;

  const CatalogItem({
    required this.name,
    required this.image,
    required this.season,
    required this.originalPrice,
    required this.salePrice,
  });
}

const _items = [
  CatalogItem(
    name: 'CACTUS',
    image: 'cactus',
    season: 'SS/20',
    originalPrice: 300,
    salePrice: 180,
  ),
  CatalogItem(
    name: 'THE EYE',
    image: 'the_eye',
    season: 'SS/20',
    originalPrice: 240,
    salePrice: 144,
  ),
  CatalogItem(
    name: 'DURAN',
    image: 'duran',
    season: 'SS/20',
    originalPrice: 240,
    salePrice: 144,
  ),
  CatalogItem(
    name: 'THE CODE',
    image: 'the_code',
    season: 'SS/20',
    originalPrice: 240,
    salePrice: 144,
  ),
  CatalogItem(
    name: 'CAMERA',
    image: 'camera',
    season: 'SS/20',
    originalPrice: 240,
    salePrice: 144,
  ),
];

class Catalog extends StatefulWidget {
  const Catalog({super.key});

  @override
  State<Catalog> createState() => _CatalogState();
}

class _CatalogState extends State<Catalog> {
  final ScrollController _scrollController = ScrollController();
  double _velocity = 0;

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onPointerMove(PointerMoveEvent event) {
    _velocity = -event.delta.dx;
    final newOffset = _scrollController.offset + _velocity;
    final max = _scrollController.position.maxScrollExtent;

    if (newOffset < 0 || newOffset > max) {
      final overscroll = newOffset < 0 ? newOffset : newOffset - max;
      _scrollController.jumpTo(
        (_scrollController.offset + overscroll * 0.15).clamp(-200, max + 200),
      );
    } else {
      _scrollController.jumpTo(newOffset);
    }
  }

  void _onPointerUp(PointerUpEvent event) {
    final max = _scrollController.position.maxScrollExtent;
    final current = _scrollController.offset;

    if (current < 0) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
      );
    } else if (current > max) {
      _scrollController.animateTo(
        max,
        duration: const Duration(milliseconds: 600),
        curve: Curves.elasticOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        SizedBox(
          height: 600,
          child: Listener(
            onPointerMove: _onPointerMove,
            onPointerUp: _onPointerUp,
            child: ListView.separated(
              controller: _scrollController,
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 60),
              physics: const NeverScrollableScrollPhysics(),
              itemCount: _items.length,
              separatorBuilder: (_, __) => const SizedBox(width: 16),
              itemBuilder: (context, index) =>
                  _CatalogCard(item: _items[index]),
            ),
          ),
        ),
        const SizedBox(height: 24),
        Padding(
          padding: const EdgeInsets.only(right: 24),
          child: ArrowsWidget(
            label: 'SHOP ALL',
            direction: ArrowDirection.right,
          ),
        ),
        const SizedBox(height: 24),
      ],
    );
  }
}

class _CatalogCard extends StatelessWidget {
  final CatalogItem item;
  const _CatalogCard({required this.item});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 380,
      decoration: BoxDecoration(
        color: const Color.fromARGB(255, 231, 214, 196),
        border: Border.all(color: Colors.black, width: 1),
      ),
      padding: const EdgeInsets.all(24),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Expanded(
            child: Image.asset(
              'assets/images/catalog/${item.image}.png',
              fit: BoxFit.contain,
            ),
          ),
          const SizedBox(height: 16),
          ...[
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(4),
              ),
              child: const Text(
                'UNISEX',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'FingerPaint',
                  fontSize: 13,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              item.season,
              style: const TextStyle(
                fontFamily: 'HedvigLettersSans',
                fontSize: 12,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              item.name,
              style: const TextStyle(
                fontFamily: 'FingerPaint',
                fontSize: 40,
                height: 1,
              ),
            ),
            const SizedBox(height: 12),
            Text(
              '€ ${item.originalPrice.toStringAsFixed(0)} EUR',
              style: const TextStyle(
                fontFamily: 'HedvigLettersSans',
                fontSize: 13,
                decoration: TextDecoration.lineThrough,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              '€ ${item.salePrice.toStringAsFixed(0)} EUR',
              style: const TextStyle(
                fontFamily: 'HedvigLettersSans',
                fontSize: 18,
                fontWeight: FontWeight.w600,
              ),
            ),
          ],
        ],
      ),
    );
  }
}
