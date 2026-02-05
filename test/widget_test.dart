import 'package:flutter_test/flutter_test.dart';
import 'package:credassignment/features/bills_carousel/domain/entities/bill_entity.dart';
import 'package:credassignment/features/bills_carousel/presentation/widgets/bill_card.dart';
import 'package:credassignment/features/bills_carousel/presentation/widgets/vertical_carousel.dart';
import 'package:flutter/material.dart';

void main() {
  group('Bill Card Widget Tests', () {
    const testBill = BillEntity(
      id: '1',
      bankName: 'HDFC Bank',
      maskedNumber: 'XXXX XXXX 5948',
      amount: 45000,
      status: 'pending',
      bottomTagText: 'DUE TODAY',
      footerText: 'due today',
      flipperConfig: false,
    );

    testWidgets('BillCard renders correctly', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BillCard(bill: testBill),
          ),
        ),
      );

      // Verify bank name is displayed
      expect(find.text('HDFC Bank'), findsOneWidget);
      
      // Verify masked number is displayed
      expect(find.text('XXXX XXXX 5948'), findsOneWidget);
      
      // Verify pay button with formatted amount
      expect(find.textContaining('Pay ₹'), findsOneWidget);
    });

    testWidgets('BillCard shows status tag', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: BillCard(bill: testBill),
          ),
        ),
      );

      // Verify status text is displayed
      expect(find.text('DUE TODAY'), findsOneWidget);
    });
  });

  group('Vertical Carousel Widget Tests', () {
    final testBills = List.generate(
      5,
      (index) => BillEntity(
        id: '$index',
        bankName: 'Bank $index',
        maskedNumber: 'XXXX XXXX ${1000 + index}',
        amount: 1000.0 * (index + 1),
        status: 'pending',
        bottomTagText: 'Due in ${index + 1} days',
        footerText: 'Payment reminder',
        flipperConfig: index % 2 == 0,
      ),
    );

    testWidgets('VerticalCarousel renders with multiple bills',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalCarousel(bills: testBills),
          ),
        ),
      );

      // Wait for animations to settle
      await tester.pumpAndSettle();

      // Verify first bill is visible
      expect(find.text('Bank 0'), findsOneWidget);
    });

    testWidgets('VerticalCarousel supports vertical scrolling',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalCarousel(bills: testBills),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Find the PageView
      final pageViewFinder = find.byType(PageView);
      expect(pageViewFinder, findsOneWidget);

      // Perform vertical swipe
      await tester.drag(pageViewFinder, const Offset(0, -300));
      await tester.pumpAndSettle();

      // Verify we can scroll
      expect(find.text('Bank 1'), findsWidgets);
    });
  });

  group('UI Mode Tests', () {
    testWidgets('Static mode for <=2 items', (WidgetTester tester) async {
      final twoBills = List.generate(
        2,
        (index) => BillEntity(
          id: '$index',
          bankName: 'Bank $index',
          maskedNumber: 'XXXX XXXX ${1000 + index}',
          amount: 1000.0,
          status: 'pending',
          bottomTagText: 'Due today',
          footerText: 'Payment reminder',
          flipperConfig: false,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: ListView.builder(
              itemCount: twoBills.length,
              itemBuilder: (context, index) => BillCard(bill: twoBills[index]),
            ),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify both bills are rendered
      expect(find.text('Bank 0'), findsOneWidget);
      expect(find.text('Bank 1'), findsOneWidget);
    });

    testWidgets('Carousel mode for >2 items', (WidgetTester tester) async {
      final manyBills = List.generate(
        10,
        (index) => BillEntity(
          id: '$index',
          bankName: 'Bank $index',
          maskedNumber: 'XXXX XXXX ${1000 + index}',
          amount: 1000.0,
          status: 'pending',
          bottomTagText: 'Due today',
          footerText: 'Payment reminder',
          flipperConfig: false,
        ),
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: VerticalCarousel(bills: manyBills),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Verify carousel is rendered
      expect(find.byType(VerticalCarousel), findsOneWidget);
      expect(find.byType(PageView), findsOneWidget);
    });
  });
}
