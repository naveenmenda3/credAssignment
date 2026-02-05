import 'package:flutter_test/flutter_test.dart';
import 'package:credassignment/features/bills_carousel/domain/entities/bill_entity.dart';
import 'package:credassignment/features/bills_carousel/presentation/widgets/bill_card.dart';
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
        const MaterialApp(
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
        const MaterialApp(
          home: Scaffold(
            body: BillCard(bill: testBill),
          ),
        ),
      );

      // Verify status text is displayed
      expect(find.text('DUE TODAY'), findsOneWidget);
    });

    testWidgets('BillCard formats amount correctly', (WidgetTester tester) async {
      const largeBill = BillEntity(
        id: '2',
        bankName: 'ICICI Bank',
        maskedNumber: 'XXXX XXXX 1234',
        amount: 45000,
        status: 'pending',
        bottomTagText: 'DUE TODAY',
        footerText: 'due today',
        flipperConfig: false,
      );

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: BillCard(bill: largeBill),
          ),
        ),
      );

      // Verify amount is formatted (45000 -> 45K or 45000)
      expect(find.textContaining('Pay ₹'), findsOneWidget);
    });
  });

  group('UI Mode Tests', () {
    testWidgets('Static mode renders bills in list', (WidgetTester tester) async {
      final twoBills = [
        const BillEntity(
          id: '1',
          bankName: 'Bank 1',
          maskedNumber: 'XXXX XXXX 1001',
          amount: 1000.0,
          status: 'pending',
          bottomTagText: 'Due today',
          footerText: 'Payment reminder',
          flipperConfig: false,
        ),
        const BillEntity(
          id: '2',
          bankName: 'Bank 2',
          maskedNumber: 'XXXX XXXX 1002',
          amount: 2000.0,
          status: 'pending',
          bottomTagText: 'Due today',
          footerText: 'Payment reminder',
          flipperConfig: false,
        ),
      ];

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
      expect(find.text('Bank 1'), findsOneWidget);
      expect(find.text('Bank 2'), findsOneWidget);
    });
  });

  group('Entity Tests', () {
    test('BillEntity equality works correctly', () {
      const bill1 = BillEntity(
        id: '1',
        bankName: 'HDFC',
        maskedNumber: 'XXXX 1234',
        amount: 1000,
        status: 'pending',
        bottomTagText: 'Due',
        footerText: 'Footer',
        flipperConfig: false,
      );

      const bill2 = BillEntity(
        id: '1',
        bankName: 'HDFC',
        maskedNumber: 'XXXX 1234',
        amount: 1000,
        status: 'pending',
        bottomTagText: 'Due',
        footerText: 'Footer',
        flipperConfig: false,
      );

      expect(bill1, equals(bill2));
    });

    test('BillEntity hashCode works correctly', () {
      const bill1 = BillEntity(
        id: '1',
        bankName: 'HDFC',
        maskedNumber: 'XXXX 1234',
        amount: 1000,
        status: 'pending',
        bottomTagText: 'Due',
        footerText: 'Footer',
        flipperConfig: false,
      );

      const bill2 = BillEntity(
        id: '1',
        bankName: 'HDFC',
        maskedNumber: 'XXXX 1234',
        amount: 1000,
        status: 'pending',
        bottomTagText: 'Due',
        footerText: 'Footer',
        flipperConfig: false,
      );

      expect(bill1.hashCode, equals(bill2.hashCode));
    });
  });
}
