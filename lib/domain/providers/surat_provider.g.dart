// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'surat_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint, type=warning

@ProviderFor(suratRepository)
final suratRepositoryProvider = SuratRepositoryProvider._();

final class SuratRepositoryProvider
    extends
        $FunctionalProvider<SuratRepository, SuratRepository, SuratRepository>
    with $Provider<SuratRepository> {
  SuratRepositoryProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suratRepositoryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suratRepositoryHash();

  @$internal
  @override
  $ProviderElement<SuratRepository> $createElement($ProviderPointer pointer) =>
      $ProviderElement(pointer);

  @override
  SuratRepository create(Ref ref) {
    return suratRepository(ref);
  }

  /// {@macro riverpod.override_with_value}
  Override overrideWithValue(SuratRepository value) {
    return $ProviderOverride(
      origin: this,
      providerOverride: $SyncValueProvider<SuratRepository>(value),
    );
  }
}

String _$suratRepositoryHash() => r'195821e2d7a6847e8f75ae9136be9ac93c7147ef';

@ProviderFor(suratMasuk)
final suratMasukProvider = SuratMasukProvider._();

final class SuratMasukProvider
    extends
        $FunctionalProvider<
          AsyncValue<List<SuratModel>>,
          List<SuratModel>,
          FutureOr<List<SuratModel>>
        >
    with $FutureModifier<List<SuratModel>>, $FutureProvider<List<SuratModel>> {
  SuratMasukProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suratMasukProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suratMasukHash();

  @$internal
  @override
  $FutureProviderElement<List<SuratModel>> $createElement(
    $ProviderPointer pointer,
  ) => $FutureProviderElement(pointer);

  @override
  FutureOr<List<SuratModel>> create(Ref ref) {
    return suratMasuk(ref);
  }
}

String _$suratMasukHash() => r'98826dae6fa701c35cf014eebed3328ef8aba659';
