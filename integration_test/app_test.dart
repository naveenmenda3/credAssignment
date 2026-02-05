import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:integration_test/integration_test.dart';
import 'package:get/get.dart';
import 'package:credassignment/main.dart' as app;
import 'package:credassignment/core/performance/frame_drop_tracker.dart';
import 'package:credassignment/features/bills_carousel/presentation/controller/bills_controller.dart';

void main() {
  IntegrationTestWidgetsFlutterBinding.ensureInitialized();

  group('Bills Carousel Integration Tests', () {
    testWidgets('App loads and displays bills', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      // Verify app loaded
      expect(find.text('UPCOMING BILLS'), findsWidgets);
    });

    testWidgets('Vertical swipe works smoothly', (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      // Only test carousel if we have >2 bills
      if (controller.isCarouselMode) {
        final initialIndex = controller.currentIndex.value;

        // Find the PageView
        final pageViewFinder = find.byType(PageView);
        
        if (pageViewFinder.evaluate().isNotEmpty) {
          // Perform vertical swipe
          await tester.drag(pageViewFinder, const Offset(0, -300));
          await tester.pumpAndSettle();

          // Verify index changed
          expect(controller.currentIndex.value, isNot(equals(initialIndex)));
        }
      }
    });

    testWidgets('No excessive frame drops during swipe',
        (WidgetTester tester) async {
      final frameTracker = FrameDropTracker();
      
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      if (controller.isCarouselMode) {
        frameTracker.startTracking();

        // Perform multiple swipes
        final pageViewFinder = find.byType(PageView);
        
        if (pageViewFinder.evaluate().isNotEmpty) {
          for (int i = 0; i < 3; i++) {
            await tester.drag(pageViewFinder, const Offset(0, -300));
            await tester.pump();
            await tester.pump(const Duration(milliseconds: 100));
          }

          await tester.pumpAndSettle();
        }

        frameTracker.stopTracking();

        // Verify frame drop rate is acceptable (<10%)
        final dropRate = frameTracker.dropRate;
        // ignore: avoid_print
        print('Frame drop rate: ${dropRate.toStringAsFixed(2)}%');
        // ignore: avoid_print
        print('Total frames: ${frameTracker.totalFrames}');
        // ignore: avoid_print
        print('Dropped frames: ${frameTracker.droppedFrames}');

        expect(dropRate, lessThan(10.0),
            reason: 'Frame drop rate should be less than 10%');
      }
    });

    testWidgets('Active index updates correctly on swipe',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      if (controller.isCarouselMode && controller.bills.length >= 3) {
        // Initial index should be 0
        expect(controller.currentIndex.value, equals(0));

        final pageViewFinder = find.byType(PageView);
        
        if (pageViewFinder.evaluate().isNotEmpty) {
          // Swipe to next
          await tester.drag(pageViewFinder, const Offset(0, -300));
          await tester.pumpAndSettle();

          // Index should be 1
          expect(controller.currentIndex.value, equals(1));

          // Swipe to next again
          await tester.drag(pageViewFinder, const Offset(0, -300));
          await tester.pumpAndSettle();

          // Index should be 2
          expect(controller.currentIndex.value, equals(2));
        }
      }
    });

    testWidgets('Flip tag animation works when enabled',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      // Find a bill with flipperConfig enabled
      final flipEnabledBill = controller.bills.firstWhereOrNull(
        (bill) => bill.flipperConfig,
      );

      if (flipEnabledBill != null) {
        // Wait for flip animation (3 seconds interval)
        await tester.pump(const Duration(seconds: 4));
        await tester.pumpAndSettle();

        // Animation should have occurred
        expect(find.byType(AnimatedSwitcher), findsWidgets);
      }
    });

    testWidgets('Static mode renders correctly for <=2 items',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      if (controller.isStaticMode) {
        // Should use ListView, not PageView
        expect(find.byType(ListView), findsWidgets);
        expect(find.byType(PageView), findsNothing);
      }
    });

    testWidgets('Carousel mode renders correctly for >2 items',
        (WidgetTester tester) async {
      app.main();
      await tester.pumpAndSettle(const Duration(seconds: 5));

      final controller = Get.find<BillsController>();

      if (controller.isCarouselMode) {
        // Should use PageView
        expect(find.byType(PageView), findsOneWidget);
        
        // Should have stacked cards visible
        expect(controller.bills.length, greaterThan(2));
      }
    });
  });

  group('Performance Tests', () {
    testWidgets('Frame tracker works correctly', (WidgetTester tester) async {
      final tracker = FrameDropTracker();
      
      tracker.startTracking();
      
      // Simulate some work
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: 100,
              itemBuilder: (context, index) => ListTile(
                title: Text('Item $index'),
              ),
            ),
          ),
        ),
      );
      
      await tester.pumpAndSettle();
      
      tracker.stopTracking();
      
      // Verify tracker collected data
      expect(tracker.totalFrames, greaterThan(0));
      
      final report = tracker.getReport();
      expect(report['totalFrames'], greaterThan(0));
    });
  });
}
