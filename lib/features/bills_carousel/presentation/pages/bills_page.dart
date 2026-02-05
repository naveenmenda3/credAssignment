import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/bills_controller.dart';
import '../widgets/vertical_carousel.dart';
import '../widgets/bill_card.dart';

/// CRED-style bills page
class BillsPage extends StatelessWidget {
  const BillsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<BillsController>();

    return Scaffold(
      backgroundColor: const Color(0xFFF8F8F8),
      body: SafeArea(
        child: Obx(() {
          // Loading state
          if (controller.isLoading.value) {
            return const Center(
              child: CircularProgressIndicator(
                color: Color(0xFF1A1A1A),
              ),
            );
          }

          // Error state
          if (controller.error.value.isNotEmpty) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(
                      Icons.error_outline,
                      size: 64,
                      color: Color(0xFFE53935),
                    ),
                    const SizedBox(height: 16),
                    Text(
                      'Failed to load bills',
                      style: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                        color: Color(0xFF1A1A1A),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.error.value,
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey[600],
                      ),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 24),
                    ElevatedButton(
                      onPressed: () => controller.retry(),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF1A1A1A),
                        foregroundColor: Colors.white,
                        padding: const EdgeInsets.symmetric(
                          horizontal: 32,
                          vertical: 14,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text(
                        'Retry',
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          }

          // Empty state
          if (controller.bills.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long_outlined,
                    size: 64,
                    color: Colors.grey[400],
                  ),
                  const SizedBox(height: 16),
                  Text(
                    'No bills found',
                    style: TextStyle(
                      fontSize: 18,
                      color: Colors.grey[600],
                    ),
                  ),
                ],
              ),
            );
          }

          // Main content
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Header
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 20, 20, 16),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          'UPCOMING BILLS (${controller.bills.length})',
                          style: TextStyle(
                            fontSize: 13,
                            fontWeight: FontWeight.w600,
                            color: Colors.grey[500],
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                    GestureDetector(
                      onTap: () {
                        // View all action
                      },
                      child: Row(
                        children: [
                          Text(
                            'view all',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.grey[700],
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(width: 4),
                          Icon(
                            Icons.chevron_right,
                            size: 20,
                            color: Colors.grey[700],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),

              // Bills content
              Expanded(
                child: _buildBillsContent(controller),
              ),
            ],
          );
        }),
      ),
    );
  }

  Widget _buildBillsContent(BillsController controller) {
    // Static list mode (<=2 items)
    if (controller.isStaticMode) {
      return ListView.builder(
        padding: const EdgeInsets.only(top: 8, bottom: 24),
        physics: const BouncingScrollPhysics(),
        itemCount: controller.bills.length,
        itemBuilder: (context, index) {
          return BillCard(
            bill: controller.bills[index],
            isCarouselMode: false,
          );
        },
      );
    }

    // Carousel mode (>2 items)
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      child: Column(
        children: [
          const SizedBox(height: 8),
          VerticalCarousel(bills: controller.bills),
          const SizedBox(height: 24),
        ],
      ),
    );
  }
}
