// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_references_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$entityReferencesHash() => r'caebe0f8f5d32fc72084f8f0849bcd109e8f6352';

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

/// See also [entityReferences].
@ProviderFor(entityReferences)
const entityReferencesProvider = EntityReferencesFamily();

/// See also [entityReferences].
class EntityReferencesFamily extends Family<AsyncValue<EntityReferences>> {
  /// See also [entityReferences].
  const EntityReferencesFamily();

  /// See also [entityReferences].
  EntityReferencesProvider call(
    String entityId,
  ) {
    return EntityReferencesProvider(
      entityId,
    );
  }

  @override
  EntityReferencesProvider getProviderOverride(
    covariant EntityReferencesProvider provider,
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
  String? get name => r'entityReferencesProvider';
}

/// See also [entityReferences].
class EntityReferencesProvider
    extends AutoDisposeFutureProvider<EntityReferences> {
  /// See also [entityReferences].
  EntityReferencesProvider(
    String entityId,
  ) : this._internal(
          (ref) => entityReferences(
            ref as EntityReferencesRef,
            entityId,
          ),
          from: entityReferencesProvider,
          name: r'entityReferencesProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$entityReferencesHash,
          dependencies: EntityReferencesFamily._dependencies,
          allTransitiveDependencies:
              EntityReferencesFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  EntityReferencesProvider._internal(
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
    FutureOr<EntityReferences> Function(EntityReferencesRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: EntityReferencesProvider._internal(
        (ref) => create(ref as EntityReferencesRef),
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
  AutoDisposeFutureProviderElement<EntityReferences> createElement() {
    return _EntityReferencesProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EntityReferencesProvider && other.entityId == entityId;
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
mixin EntityReferencesRef on AutoDisposeFutureProviderRef<EntityReferences> {
  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _EntityReferencesProviderElement
    extends AutoDisposeFutureProviderElement<EntityReferences>
    with EntityReferencesRef {
  _EntityReferencesProviderElement(super.provider);

  @override
  String get entityId => (origin as EntityReferencesProvider).entityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
