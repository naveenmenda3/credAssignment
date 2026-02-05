import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/bill_entity.dart';
import '../controller/bills_controller.dart';
import 'bill_card.dart';

/// CRED-style vertical carousel with stacked cards and depth effect
class VerticalCarousel extends StatefulWidget {
  final List<BillEntity> bills;

  const VerticalCarousel({
    super.key,
    required this.bills,
  });

  @override
  State<VerticalCarousel> createState() => _VerticalCarouselState();
}

class _VerticalCarouselState extends State<VerticalCarousel> {
  late PageController _pageController;
  final BillsController _controller = Get.find<BillsController>();
  double _currentPage = 0.0;

  // Configuration for stacking effect
  static const double _cardHeight = 180.0;
  static const double _stackOffset = 12.0; // Vertical offset for stacked cards
  static const double _scaleReduction = 0.05; // Scale reduction per card
  static const int _visibleStackedCards = 2; // Number of cards visible behind

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      initialPage: _controller.currentIndex.value,
      viewportFraction: 1.0,
    );
    
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page ?? 0.0;
      });
    });
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: _cardHeight + (_stackOffset * _visibleStackedCards) + 40,
      child: Stack(
        children: [
          // Background stacked cards
          ..._buildStackedCards(),
          
          // Main PageView
          PageView.builder(
            controller: _pageController,
            scrollDirection: Axis.vertical,
            physics: const BouncingScrollPhysics(),
            itemCount: widget.bills.length,
            onPageChanged: (index) {
              _controller.updateCurrentIndex(index);
            },
            itemBuilder: (context, index) {
              return Container(
                height: _cardHeight,
                alignment: Alignment.topCenter,
                child: BillCard(
                  bill: widget.bills[index],
                  isCarouselMode: true,
                ),
              );
            },
          ),
        ],
      ),
    );
  }

  /// Build stacked cards behind the active card
  List<Widget> _buildStackedCards() {
    final currentIndex = _currentPage.floor();
    final nextIndex = _currentPage.ceil();
    final progress = _currentPage - currentIndex;
    
    List<Widget> stackedCards = [];
    
    // Build cards that should be visible behind
    for (int i = 1; i <= _visibleStackedCards; i++) {
      final cardIndex = currentIndex + i;
      
      if (cardIndex < widget.bills.length) {
        // Calculate position and scale based on transition progress
        double offset;
        double scale;
        
        if (cardIndex == nextIndex && progress > 0) {
          // Card is transitioning to become active
          offset = _stackOffset * (i - progress);
          scale = 1.0 - (_scaleReduction * (i - progress));
        } else {
          // Card is in stack
          offset = _stackOffset * i;
          scale = 1.0 - (_scaleReduction * i);
        }
        
        stackedCards.add(
          Positioned(
            top: offset,
            left: 0,
            right: 0,
            child: IgnorePointer(
              child: Transform.scale(
                scale: scale,
                alignment: Alignment.topCenter,
                child: Opacity(
                  opacity: 1.0 - (i * 0.15), // Slight opacity reduction
                  child: Container(
                    height: _cardHeight,
                    alignment: Alignment.topCenter,
                    child: BillCard(
                      bill: widget.bills[cardIndex],
                      isCarouselMode: true,
                    ),
                  ),
                ),
              ),
            ),
          ),
        );
      }
    }
    
    return stackedCards;
  }
}
