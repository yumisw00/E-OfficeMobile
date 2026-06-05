import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../data/models/surat_model.dart';
import '../../data/repositories/surat_repository.dart';

part 'surat_provider.g.dart';

@riverpod
SuratRepository suratRepository(Ref ref) {
  return MockSuratRepository();
}

@riverpod
Future<List<SuratModel>> suratMasuk(Ref ref) async {
  final repository = ref.watch(suratRepositoryProvider);
  return repository.getSuratMasuk();
}
