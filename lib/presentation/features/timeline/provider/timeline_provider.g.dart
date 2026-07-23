// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$timelineListHash() => r'ba587b41b9bf7c5e0b162f8fa835a58662d16556';

/// Copied from Dart SDK
class _SystemHash {
  _SystemHash._();

  static int combine(int hash, int value) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + value);
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int finish(int hash) {
    // ignore: parameter_assignments
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    // ignore: parameter_assignments
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }
}

abstract class _$TimelineList
    extends BuildlessAutoDisposeAsyncNotifier<List<TimelineEntry>> {
  late final String? entityId;

  FutureOr<List<TimelineEntry>> build({
    String? entityId,
  });
}

/// See also [TimelineList].
@ProviderFor(TimelineList)
const timelineListProvider = TimelineListFamily();

/// See also [TimelineList].
class TimelineListFamily extends Family<AsyncValue<List<TimelineEntry>>> {
  /// See also [TimelineList].
  const TimelineListFamily();

  /// See also [TimelineList].
  TimelineListProvider call({
    String? entityId,
  }) {
    return TimelineListProvider(
      entityId: entityId,
    );
  }

  @override
  TimelineListProvider getProviderOverride(
    covariant TimelineListProvider provider,
  ) {
    return call(
      entityId: provider.entityId,
    );
  }

  static const Iterable<ProviderOrFamily>? _dependencies = null;

  @override
  Iterable<ProviderOrFamily>? get dependencies => _dependencies;

  static const Iterable<ProviderOrFamily>? _allTransitiveDependencies = null;

  @override
  Iterable<ProviderOrFamily>? get allTransitiveDependencies =>
      _allTransitiveDependencies;

  @override
  String? get name => r'timelineListProvider';
}

/// See also [TimelineList].
class TimelineListProvider extends AutoDisposeAsyncNotifierProviderImpl<
    TimelineList, List<TimelineEntry>> {
  /// See also [TimelineList].
  TimelineListProvider({
    String? entityId,
  }) : this._internal(
          () => TimelineList()..entityId = entityId,
          from: timelineListProvider,
          name: r'timelineListProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$timelineListHash,
          dependencies: TimelineListFamily._dependencies,
          allTransitiveDependencies:
              TimelineListFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  TimelineListProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityId,
  }) : super.internal();

  final String? entityId;

  @override
  FutureOr<List<TimelineEntry>> runNotifierBuild(
    covariant TimelineList notifier,
  ) {
    return notifier.build(
      entityId: entityId,
    );
  }

  @override
  Override overrideWith(TimelineList Function() create) {
    return ProviderOverride(
      origin: this,
      override: TimelineListProvider._internal(
        () => create()..entityId = entityId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        entityId: entityId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<TimelineList, List<TimelineEntry>>
      createElement() {
    return _TimelineListProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is TimelineListProvider && other.entityId == entityId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, entityId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin TimelineListRef
    on AutoDisposeAsyncNotifierProviderRef<List<TimelineEntry>> {
  /// The parameter `entityId` of this provider.
  String? get entityId;
}

class _TimelineListProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<TimelineList,
        List<TimelineEntry>> with TimelineListRef {
  _TimelineListProviderElement(super.provider);

  @override
  String? get entityId => (origin as TimelineListProvider).entityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
