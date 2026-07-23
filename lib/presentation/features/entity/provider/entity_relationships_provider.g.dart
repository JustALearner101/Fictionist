// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_relationships_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$entityRelationshipsHash() =>
    r'5458aaa7db88b7b1394cd8a128d46af9d7df6f6b';

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

/// See also [entityRelationships].
@ProviderFor(entityRelationships)
const entityRelationshipsProvider = EntityRelationshipsFamily();

/// See also [entityRelationships].
class EntityRelationshipsFamily extends Family<AsyncValue<List<Relationship>>> {
  /// See also [entityRelationships].
  const EntityRelationshipsFamily();

  /// See also [entityRelationships].
  EntityRelationshipsProvider call(
    String entityId,
  ) {
    return EntityRelationshipsProvider(
      entityId,
    );
  }

  @override
  EntityRelationshipsProvider getProviderOverride(
    covariant EntityRelationshipsProvider provider,
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
  String? get name => r'entityRelationshipsProvider';
}

/// See also [entityRelationships].
class EntityRelationshipsProvider
    extends AutoDisposeFutureProvider<List<Relationship>> {
  /// See also [entityRelationships].
  EntityRelationshipsProvider(
    String entityId,
  ) : this._internal(
          (ref) => entityRelationships(
            ref as EntityRelationshipsRef,
            entityId,
          ),
          from: entityRelationshipsProvider,
          name: r'entityRelationshipsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$entityRelationshipsHash,
          dependencies: EntityRelationshipsFamily._dependencies,
          allTransitiveDependencies:
              EntityRelationshipsFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  EntityRelationshipsProvider._internal(
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
    FutureOr<List<Relationship>> Function(EntityRelationshipsRef provider)
        create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EntityRelationshipsProvider._internal(
        (ref) => create(ref as EntityRelationshipsRef),
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
  AutoDisposeFutureProviderElement<List<Relationship>> createElement() {
    return _EntityRelationshipsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EntityRelationshipsProvider && other.entityId == entityId;
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
mixin EntityRelationshipsRef
    on AutoDisposeFutureProviderRef<List<Relationship>> {
  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _EntityRelationshipsProviderElement
    extends AutoDisposeFutureProviderElement<List<Relationship>>
    with EntityRelationshipsRef {
  _EntityRelationshipsProviderElement(super.provider);

  @override
  String get entityId => (origin as EntityRelationshipsProvider).entityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
