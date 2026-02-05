import 'package:get/get.dart';
import '../../domain/entities/bill_entity.dart';
import '../../domain/repositories/bills_repository.dart';

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
    fetchBills();
  }

  /// Fetch bills from repository
  Future<void> fetchBills() async {
    try {
      isLoading.value = true;
      error.value = '';

      final fetchedBills = await _repository.getBills();
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
    fetchBills();
  }

  /// Refresh bills
  Future<void> refresh() async {
    await fetchBills();
  }
}
