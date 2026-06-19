import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:e_office_mobile/core/routing/app_router.dart';

void main() {
  runApp(
    const ProviderScope(
      child: EOfficeApp(),
    ),
  );
}

// 1. Ubah StatelessWidget menjadi ConsumerWidget
class EOfficeApp extends ConsumerWidget {
  const EOfficeApp({super.key});

  @override
  // 2. Tambahkan WidgetRef ref ke dalam metode build
  Widget build(BuildContext context, WidgetRef ref) {
    // 3. Panggil router menggunakan ref.watch
    // riverpod_generator otomatis menambahkan kata 'Provider' di akhir nama fungsi
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'E-Office Dahana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      // 4. Masukkan variabel router yang sudah dipantau
      routerConfig: router,
    );
  }
}