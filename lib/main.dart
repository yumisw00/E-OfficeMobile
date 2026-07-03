import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:e_office_mobile/core/routing/app_router.dart';
import 'package:e_office_mobile/core/network/firebase_messaging_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Inisialisasi Firebase
  await Firebase.initializeApp();
  
  // Inisialisasi Firebase Messaging Service
  await FirebaseMessagingService().init();

  runApp(
    const ProviderScope(
      child: EOfficeApp(),
    ),
  );
}

class EOfficeApp extends ConsumerWidget {
  const EOfficeApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(appRouterProvider);

    return MaterialApp.router(
      title: 'E-Office Dahana',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blueAccent),
        useMaterial3: true,
      ),
      routerConfig: router,
    );
  }
}
