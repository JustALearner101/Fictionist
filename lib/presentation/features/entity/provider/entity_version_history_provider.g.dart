// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_version_history_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$entityVersionHistoryHash() =>
    r'8967757897e0ef3d178efbdf2f683ed9f2bdbb1b';

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

/// See also [entityVersionHistory].
@ProviderFor(entityVersionHistory)
const entityVersionHistoryProvider = EntityVersionHistoryFamily();

/// See also [entityVersionHistory].
class EntityVersionHistoryFamily
    extends Family<AsyncValue<List<EntityVersion>>> {
  /// See also [entityVersionHistory].
  const EntityVersionHistoryFamily();

  /// See also [entityVersionHistory].
  EntityVersionHistoryProvider call(
    String entityId,
  ) {
    return EntityVersionHistoryProvider(
      entityId,
    );
  }

  @override
  EntityVersionHistoryProvider getProviderOverride(
    covariant EntityVersionHistoryProvider provider,
  ) {
    return call(
      provider.entityId,
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
  String? get name => r'entityVersionHistoryProvider';
}

/// See also [entityVersionHistory].
class EntityVersionHistoryProvider
    extends AutoDisposeFutureProvider<List<EntityVersion>> {
  /// See also [entityVersionHistory].
  EntityVersionHistoryProvider(
    String entityId,
  ) : this._internal(
          (ref) => entityVersionHistory(
            ref as EntityVersionHistoryRef,
            entityId,
          ),
          from: entityVersionHistoryProvider,
          name: r'entityVersionHistoryProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$entityVersionHistoryHash,
          dependencies: EntityVersionHistoryFamily._dependencies,
          allTransitiveDependencies:
              EntityVersionHistoryFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  EntityVersionHistoryProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.entityId,
  }) : super.internal();

  final String entityId;

  @override
  Override overrideWith(
    FutureOr<List<EntityVersion>> Function(EntityVersionHistoryRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EntityVersionHistoryProvider._internal(
        (ref) => create(ref as EntityVersionHistoryRef),
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
  AutoDisposeFutureProviderElement<List<EntityVersion>> createElement() {
    return _EntityVersionHistoryProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EntityVersionHistoryProvider && other.entityId == entityId;
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
mixin EntityVersionHistoryRef
    on AutoDisposeFutureProviderRef<List<EntityVersion>> {
  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _EntityVersionHistoryProviderElement
    extends AutoDisposeFutureProviderElement<List<EntityVersion>>
    with EntityVersionHistoryRef {
  _EntityVersionHistoryProviderElement(super.provider);

  @override
  String get entityId => (origin as EntityVersionHistoryProvider).entityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
