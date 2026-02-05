import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'core/network/dio_client.dart';
import 'features/bills_carousel/data/datasources/bills_remote_ds.dart';
import 'features/bills_carousel/data/repositories/bills_repo_impl.dart';
import 'features/bills_carousel/domain/repositories/bills_repository.dart';
import 'features/bills_carousel/presentation/controller/bills_controller.dart';
import 'features/bills_carousel/presentation/pages/bills_page.dart';

void main() {
  // Initialize dependencies
  _initDependencies();

  runApp(const MyApp());
}

/// Initialize GetX dependencies
void _initDependencies() {
  // Core
  Get.lazyPut<DioClient>(() => DioClient(), fenix: true);

  // Data sources
  Get.lazyPut<BillsRemoteDataSource>(
    () => BillsRemoteDataSource(Get.find<DioClient>()),
    fenix: true,
  );

  // Repositories
  Get.lazyPut<BillsRepository>(
    () => BillsRepositoryImpl(Get.find<BillsRemoteDataSource>()),
    fenix: true,
  );

  // Controllers
  Get.lazyPut<BillsController>(
    () => BillsController(Get.find<BillsRepository>()),
    fenix: true,
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: 'Bills Carousel',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1976D2),
        ),
        useMaterial3: true,
        fontFamily: 'Roboto',
      ),
      home: const BillsPage(),
    );
  }
}
