import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../domain/entities/bill_entity.dart';
import '../controller/bills_controller.dart';
import 'bill_card.dart';

/// Vertical carousel widget with smooth animations
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

  @override
  void initState() {
    super.initState();
    _pageController = PageController(
      viewportFraction: 0.85,
      initialPage: _controller.currentIndex.value,
    );
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: MediaQuery.of(context).size.height * 0.65,
      child: PageView.builder(
        controller: _pageController,
        scrollDirection: Axis.vertical,
        itemCount: widget.bills.length,
        onPageChanged: (index) {
          _controller.updateCurrentIndex(index);
        },
        itemBuilder: (context, index) {
          return Obx(() {
            final currentPage = _controller.currentIndex.value;
            final isCurrentPage = index == currentPage;

            return AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              curve: Curves.easeInOut,
              margin: EdgeInsets.symmetric(
                vertical: isCurrentPage ? 8.0 : 16.0,
                horizontal: 16.0,
              ),
              child: Transform.scale(
                scale: isCurrentPage ? 1.0 : 0.9,
                child: Opacity(
                  opacity: isCurrentPage ? 1.0 : 0.6,
                  child: BillCard(bill: widget.bills[index]),
                ),
              ),
            );
          });
        },
      ),
    );
  }
}
