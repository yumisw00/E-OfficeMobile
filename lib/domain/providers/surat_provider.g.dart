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

String _$suratRepositoryHash() => r'5c1993a24e4fbd26f0618c1e84177ac65b623cbc';

/// Provider untuk daftar Surat Masuk

@ProviderFor(SuratMasuk)
final suratMasukProvider = SuratMasukProvider._();

/// Provider untuk daftar Surat Masuk
final class SuratMasukProvider
    extends $AsyncNotifierProvider<SuratMasuk, List<SuratModel>> {
  /// Provider untuk daftar Surat Masuk
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
  SuratMasuk create() => SuratMasuk();
}

String _$suratMasukHash() => r'ee8f1e94d943ac5ffc80c0766f0a13e618c90898';

/// Provider untuk daftar Surat Masuk

abstract class _$SuratMasuk extends $AsyncNotifier<List<SuratModel>> {
  FutureOr<List<SuratModel>> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<SuratModel>>, List<SuratModel>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<SuratModel>>, List<SuratModel>>,
              AsyncValue<List<SuratModel>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider untuk ringkasan/statistik surat masuk

@ProviderFor(SuratSummaryNotifier)
final suratSummaryProvider = SuratSummaryNotifierProvider._();

/// Provider untuk ringkasan/statistik surat masuk
final class SuratSummaryNotifierProvider
    extends $AsyncNotifierProvider<SuratSummaryNotifier, SuratSummary> {
  /// Provider untuk ringkasan/statistik surat masuk
  SuratSummaryNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'suratSummaryProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$suratSummaryNotifierHash();

  @$internal
  @override
  SuratSummaryNotifier create() => SuratSummaryNotifier();
}

String _$suratSummaryNotifierHash() =>
    r'60c32ea470bcb5d7a426c858e11061201f710f46';

/// Provider untuk ringkasan/statistik surat masuk

abstract class _$SuratSummaryNotifier extends $AsyncNotifier<SuratSummary> {
  FutureOr<SuratSummary> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<SuratSummary>, SuratSummary>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<SuratSummary>, SuratSummary>,
              AsyncValue<SuratSummary>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider untuk timeline surat

@ProviderFor(SuratTimeline)
final suratTimelineProvider = SuratTimelineFamily._();

/// Provider untuk timeline surat
final class SuratTimelineProvider
    extends $AsyncNotifierProvider<SuratTimeline, List<TimelineEvent>> {
  /// Provider untuk timeline surat
  SuratTimelineProvider._({
    required SuratTimelineFamily super.from,
    required String super.argument,
  }) : super(
         retry: null,
         name: r'suratTimelineProvider',
         isAutoDispose: true,
         dependencies: null,
         $allTransitiveDependencies: null,
       );

  @override
  String debugGetCreateSourceHash() => _$suratTimelineHash();

  @override
  String toString() {
    return r'suratTimelineProvider'
        ''
        '($argument)';
  }

  @$internal
  @override
  SuratTimeline create() => SuratTimeline();

  @override
  bool operator ==(Object other) {
    return other is SuratTimelineProvider && other.argument == argument;
  }

  @override
  int get hashCode {
    return argument.hashCode;
  }
}

String _$suratTimelineHash() => r'040639dcb2447a190f3ba4a574cd7d80913cd6e3';

/// Provider untuk timeline surat

final class SuratTimelineFamily extends $Family
    with
        $ClassFamilyOverride<
          SuratTimeline,
          AsyncValue<List<TimelineEvent>>,
          List<TimelineEvent>,
          FutureOr<List<TimelineEvent>>,
          String
        > {
  SuratTimelineFamily._()
    : super(
        retry: null,
        name: r'suratTimelineProvider',
        dependencies: null,
        $allTransitiveDependencies: null,
        isAutoDispose: true,
      );

  /// Provider untuk timeline surat

  SuratTimelineProvider call(String suratId) =>
      SuratTimelineProvider._(argument: suratId, from: this);

  @override
  String toString() => r'suratTimelineProvider';
}

/// Provider untuk timeline surat

abstract class _$SuratTimeline extends $AsyncNotifier<List<TimelineEvent>> {
  late final _$args = ref.$arg as String;
  String get suratId => _$args;

  FutureOr<List<TimelineEvent>> build(String suratId);
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref =
        this.ref as $Ref<AsyncValue<List<TimelineEvent>>, List<TimelineEvent>>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<List<TimelineEvent>>, List<TimelineEvent>>,
              AsyncValue<List<TimelineEvent>>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, () => build(_$args));
  }
}

/// Provider untuk disposisi - membuat disposisi baru

@ProviderFor(DisposisiNotifier)
final disposisiProvider = DisposisiNotifierProvider._();

/// Provider untuk disposisi - membuat disposisi baru
final class DisposisiNotifierProvider
    extends $AsyncNotifierProvider<DisposisiNotifier, void> {
  /// Provider untuk disposisi - membuat disposisi baru
  DisposisiNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'disposisiProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$disposisiNotifierHash();

  @$internal
  @override
  DisposisiNotifier create() => DisposisiNotifier();
}

String _$disposisiNotifierHash() => r'3278a2f50885a4e26b0a6af7b2d15445b25ec46c';

/// Provider untuk disposisi - membuat disposisi baru

abstract class _$DisposisiNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}

/// Provider untuk approval surat keluar

@ProviderFor(ApprovalNotifier)
final approvalProvider = ApprovalNotifierProvider._();

/// Provider untuk approval surat keluar
final class ApprovalNotifierProvider
    extends $AsyncNotifierProvider<ApprovalNotifier, void> {
  /// Provider untuk approval surat keluar
  ApprovalNotifierProvider._()
    : super(
        from: null,
        argument: null,
        retry: null,
        name: r'approvalProvider',
        isAutoDispose: true,
        dependencies: null,
        $allTransitiveDependencies: null,
      );

  @override
  String debugGetCreateSourceHash() => _$approvalNotifierHash();

  @$internal
  @override
  ApprovalNotifier create() => ApprovalNotifier();
}

String _$approvalNotifierHash() => r'8e7f1c1acfdd0afe69fb29b5002a142a49148512';

/// Provider untuk approval surat keluar

abstract class _$ApprovalNotifier extends $AsyncNotifier<void> {
  FutureOr<void> build();
  @$mustCallSuper
  @override
  WhenComplete runBuild() {
    final ref = this.ref as $Ref<AsyncValue<void>, void>;
    final element =
        ref.element
            as $ClassProviderElement<
              AnyNotifier<AsyncValue<void>, void>,
              AsyncValue<void>,
              Object?,
              Object?
            >;
    return element.handleCreate(ref, build);
  }
}
