import '../entities/bill_entity.dart';

/// Abstract repository interface for bills
abstract class BillsRepository {
  /// Fetch all bills
  Future<List<BillEntity>> getBills();
}
