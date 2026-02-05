import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../core/network/api_endpoints.dart';
import '../models/bill_model.dart';

/// Remote data source for fetching bills from CRED mock APIs
class BillsRemoteDataSource {
  final DioClient _dioClient;

  BillsRemoteDataSource(this._dioClient);

  /// Fetch bills from CRED mock API
  /// Single method with configurable endpoint via BillsMockType
  Future<List<BillModel>> getBills(BillsMockType type) async {
    try {
      // Single switch point for API selection
      final url = type == BillsMockType.twoItems
          ? ApiEndpoints.mockTwoItems
          : ApiEndpoints.mockManyItems;

      final response = await _dioClient.dio.get(url);

      if (response.statusCode == 200) {
        return _parseBills(response.data);
      } else {
        throw Exception('Failed to fetch bills: ${response.statusCode}');
      }
    } on DioException catch (e) {
      throw Exception('Network error: ${e.message}');
    } catch (e) {
      throw Exception('Failed to parse bills data: $e');
    }
  }

  /// Parse bills from API response
  /// Handles CRED's nested JSON structure
  List<BillModel> _parseBills(dynamic data) {
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
  }
}
