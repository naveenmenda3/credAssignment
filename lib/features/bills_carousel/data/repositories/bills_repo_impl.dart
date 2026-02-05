import '../../domain/entities/bill_entity.dart';
import '../../domain/repositories/bills_repository.dart';
import '../datasources/bills_remote_ds.dart';

/// Implementation of BillsRepository
class BillsRepositoryImpl implements BillsRepository {
  final BillsRemoteDataSource _remoteDataSource;

  BillsRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<BillEntity>> getBills() async {
    try {
      // Use real API data
      final billModels = await _remoteDataSource.fetchBillsAuto();

      // Convert models to entities
      return billModels.map((model) => model.toEntity()).toList();
    } catch (e) {
      throw Exception('Failed to get bills: $e');
    }
  }
}
