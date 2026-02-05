import 'package:get/get.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/repositories/bills_repository.dart';
import '../../../../core/network/api_endpoints.dart';

/// GetX controller for bills feature
class BillsController extends GetxController {
  final BillsRepository _repository;

  BillsController(this._repository);

  // Reactive state
  final RxBool isLoading = false.obs;
  final RxString error = ''.obs;
  final RxList<BillEntity> bills = <BillEntity>[].obs;
  final RxInt currentIndex = 0.obs;

  // UI mode determination
  bool get isCarouselMode => bills.length > 2;
  bool get isStaticMode => bills.length <= 2;

  @override
  void onInit() {
    super.onInit();
    // Single switch point for development/testing
    // Change this ONE line to test different scenarios
    fetchBills(BillsMockType.manyItems);
  }

  /// Fetch bills from repository
  /// This is the ONLY place where we decide which mock API to use
  Future<void> fetchBills(BillsMockType type) async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedBills = await _repository.getBills(type);
      bills.value = fetchedBills;

      if (fetchedBills.isEmpty) {
        error.value = 'No bills found';
      }
    } catch (e) {
      error.value = e.toString();
      bills.clear();
    } finally {
      isLoading.value = false;
    }
  }

  /// Update current index (for carousel)
  void updateCurrentIndex(int index) {
    currentIndex.value = index;
  }

  /// Retry fetching bills
  void retry() {
    fetchBills(BillsMockType.manyItems);
  }

  /// Refresh bills
  Future<void> refresh() async {
    await fetchBills(BillsMockType.manyItems);
  }
}
