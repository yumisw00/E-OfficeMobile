import 'package:flutter/foundation.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/surat_model.dart';
import '../../data/repositories/surat_repository.dart';
import '../../core/network/dio_client.dart';
import '../../core/constants/app_config.dart';

part 'surat_provider.g.dart';

@riverpod
SuratRepository suratRepository(Ref ref) {
  final dio = ref.watch(dioProvider);
  return ApiSuratRepository(dio);
}

/// Provider untuk daftar Surat Masuk
@riverpod
class SuratMasuk extends _$SuratMasuk {
  @override
  FutureOr<List<SuratModel>> build() async {
    final repository = ref.watch(suratRepositoryProvider);
    return repository.getSuratMasuk(page: 1, pageSize: 20);
  }

  /// Refresh data surat masuk
  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      final result = await repository.getSuratMasuk(page: 1, pageSize: 20);
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }

  /// Load more data untuk pagination
  Future<void> loadMore(int page) async {
    final currentList = state.value;
    if (currentList == null) return;

    try {
      final repository = ref.read(suratRepositoryProvider);
      final newItems = await repository.getSuratMasuk(page: page, pageSize: 20);
      final combined = [...currentList, ...newItems];
      state = AsyncValue.data(combined);
    } catch (e) {
      if (AppConfig.enableLogging) {
        debugPrint('❌ Error loading more: $e');
      }
    }
  }
}

/// Provider untuk ringkasan/statistik surat masuk
@riverpod
class SuratSummaryNotifier extends _$SuratSummaryNotifier {
  @override
  FutureOr<SuratSummary> build() async {
    final repository = ref.watch(suratRepositoryProvider);
    return repository.getSuratMasukSummary();
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      final result = await repository.getSuratMasukSummary();
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider untuk timeline surat
@riverpod
class SuratTimeline extends _$SuratTimeline {
  @override
  FutureOr<List<TimelineEvent>> build(String suratId) async {
    final repository = ref.watch(suratRepositoryProvider);
    return repository.getSuratMasukTimeline(suratId);
  }

  Future<void> refresh() async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      final result = await repository.getSuratMasukTimeline(ref.watch(suratTimelineProvider.arg));
      state = AsyncValue.data(result);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
    }
  }
}

/// Provider untuk disposisi - membuat disposisi baru
@riverpod
class DisposisiNotifier extends _$DisposisiNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> createDisposisi({
    required String idSuratMasuk,
    required String idPenerima,
    required String instruksi,
    DateTime? tanggalJatuhTempo,
  }) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      await repository.createDisposisi(
        idSuratMasuk: idSuratMasuk,
        idPenerima: idPenerima,
        instruksi: instruksi,
        tanggalJatuhTempo: tanggalJatuhTempo,
      );
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}

/// Provider untuk approval surat keluar
@riverpod
class ApprovalNotifier extends _$ApprovalNotifier {
  @override
  FutureOr<void> build() => null;

  Future<void> approveSurat(String idSuratKeluar) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      await repository.approveSuratKeluar(idSuratKeluar);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<void> rejectSurat(String idSuratKeluar, String catatanRevisi) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      await repository.rejectSuratKeluar(idSuratKeluar, catatanRevisi);
      state = const AsyncValue.data(null);
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }

  Future<String> signSurat(String idSuratKeluar) async {
    state = const AsyncValue.loading();
    try {
      final repository = ref.read(suratRepositoryProvider);
      final qrCodeUrl = await repository.signSuratKeluar(idSuratKeluar);
      state = const AsyncValue.data(null);
      return qrCodeUrl;
    } catch (e, st) {
      state = AsyncValue.error(e, st);
      rethrow;
    }
  }
}
