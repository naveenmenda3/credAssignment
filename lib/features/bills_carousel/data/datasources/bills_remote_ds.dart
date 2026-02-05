import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/bill_model.dart';

/// Remote data source for fetching bills
class BillsRemoteDataSource {
  final DioClient _dioClient;

  BillsRemoteDataSource(this._dioClient);

  /// Fetch bills from remote API
  Future<List<BillModel>> fetchBills() async {
    try {
      // Mock API endpoint - replace with actual endpoint
      final response = await _dioClient.get('/bills');

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle both array and object with 'data' key
        final List<dynamic> billsJson = data is List ? data : data['data'] ?? [];

        return billsJson
            .map((json) => BillModel.fromJson(json as Map<String, dynamic>))
            .toList();
      } else {
        throw Exception('Failed to fetch bills: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse bills data: $e');
    }
  }

  /// Mock method for testing - returns sample data
  Future<List<BillModel>> fetchMockBills() async {
    // Simulate network delay
    await Future.delayed(const Duration(seconds: 1));

    return [
      const BillModel(
        id: '1',
        bankName: 'HDFC Bank',
        maskedNumber: '**** **** **** 1234',
        amount: 5000.00,
        status: 'pending',
        bottomTagText: 'Due in 3 days',
        footerText: 'Pay now to avoid late fees',
        flipperConfig: true,
      ),
      const BillModel(
        id: '2',
        bankName: 'ICICI Bank',
        maskedNumber: '**** **** **** 5678',
        amount: 12500.50,
        status: 'overdue',
        bottomTagText: 'Overdue by 2 days',
        footerText: 'Late fee applied',
        flipperConfig: false,
      ),
      const BillModel(
        id: '3',
        bankName: 'Axis Bank',
        maskedNumber: '**** **** **** 9012',
        amount: 8750.25,
        status: 'pending',
        bottomTagText: 'Due today',
        footerText: 'Payment reminder',
        flipperConfig: true,
      ),
      const BillModel(
        id: '4',
        bankName: 'SBI Card',
        maskedNumber: '**** **** **** 3456',
        amount: 3200.00,
        status: 'paid',
        bottomTagText: 'Paid on time',
        footerText: 'Thank you for your payment',
        flipperConfig: false,
      ),
    ];
  }
}
