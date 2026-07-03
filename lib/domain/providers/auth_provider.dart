import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

part 'auth_provider.g.dart';

@riverpod
class AuthNotifier extends _$AuthNotifier {
  final _storage = const FlutterSecureStorage();

  @override
  bool build() {
    return false;
  }

  Future<void> login(String email, String password) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(seconds: 2));

    // Simpan dummy token
    await _storage.write(key: 'jwt_token', value: 'dummy_token_123');

    // Update state
    state = true;
  }

  Future<void> logout() async {
    await _storage.delete(key: 'jwt_token');
    state = false;
  }
}
