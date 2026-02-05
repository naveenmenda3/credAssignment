import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../models/bill_model.dart';

/// Remote data source for fetching bills from CRED mock APIs
class BillsRemoteDataSource {
  final DioClient _dioClient;

  // CRED Mock API endpoints
  static const String _mockApiLessThan2 = 'https://api.mocklets.com/p26/mock1';
  static const String _mockApiMoreThan2 = 'https://api.mocklets.com/p26/mock2';

  BillsRemoteDataSource(this._dioClient);

  /// Fetch bills from CRED mock API
  /// Automatically selects the appropriate endpoint based on expected count
  Future<List<BillModel>> fetchBills({bool useLargeDataset = true}) async {
    try {
      final endpoint = useLargeDataset ? _mockApiMoreThan2 : _mockApiLessThan2;
      
      final response = await _dioClient.dio.get(endpoint);

      if (response.statusCode == 200) {
        final data = response.data;

        // Handle the CRED API response structure
        List<dynamic> billsJson;
        
        if (data is List) {
          // Direct array response
          billsJson = data;
        } else if (data is Map) {
          // Check for nested structure: template_properties.child_list
          final templateProps = data['template_properties'] as Map<String, dynamic>?;
          if (templateProps != null && templateProps.containsKey('child_list')) {
            billsJson = templateProps['child_list'] as List<dynamic>;
          } else if (data.containsKey('child_list')) {
            // Direct child_list
            billsJson = data['child_list'] as List<dynamic>;
          } else if (data.containsKey('data')) {
            // Fallback to 'data' key
            billsJson = data['data'] as List<dynamic>;
          } else if (data.containsKey('bills')) {
            // Fallback to 'bills' key
            billsJson = data['bills'] as List<dynamic>;
          } else {
            throw Exception('Could not find bills array in API response');
          }
        } else {
          throw Exception('Unexpected API response structure');
        }

        if (billsJson.isEmpty) {
          throw Exception('No bills found in API response');
        }

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

  /// Fetch bills with automatic endpoint selection
  Future<List<BillModel>> fetchBillsAuto() async {
    try {
      // Try the larger dataset first
      return await fetchBills(useLargeDataset: true);
    } catch (e) {
      // Fallback to smaller dataset
      try {
        return await fetchBills(useLargeDataset: false);
      } catch (e) {
        rethrow;
      }
    }
  }
}
