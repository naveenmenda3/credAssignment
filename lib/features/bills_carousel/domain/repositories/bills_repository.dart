import '../entities/bill_entity.dart';
import '../../../../core/network/api_endpoints.dart';

/// Abstract repository interface for bills
abstract class BillsRepository {
  /// Fetch bills with specified mock type
  /// This allows testing different scenarios (≤2 items vs >2 items)
  Future<List<BillEntity>> getBills(BillsMockType type);
}
