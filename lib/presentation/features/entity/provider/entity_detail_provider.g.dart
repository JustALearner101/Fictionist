// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'entity_detail_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$entityDetailHash() => r'846b3802b672c54c8caa49045c8ebd6b48220c2c';

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

abstract class _$EntityDetail
    extends BuildlessAutoDisposeAsyncNotifier<Entity> {
  late final String entityId;

  FutureOr<Entity> build(
    String entityId,
  );
}

/// See also [EntityDetail].
@ProviderFor(EntityDetail)
const entityDetailProvider = EntityDetailFamily();

/// See also [EntityDetail].
class EntityDetailFamily extends Family<AsyncValue<Entity>> {
  /// See also [EntityDetail].
  const EntityDetailFamily();

  /// See also [EntityDetail].
  EntityDetailProvider call(
    String entityId,
  ) {
    return EntityDetailProvider(
      entityId,
    );
  }

  @override
  EntityDetailProvider getProviderOverride(
    covariant EntityDetailProvider provider,
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
  String? get name => r'entityDetailProvider';
}

/// See also [EntityDetail].
class EntityDetailProvider
    extends AutoDisposeAsyncNotifierProviderImpl<EntityDetail, Entity> {
  /// See also [EntityDetail].
  EntityDetailProvider(
    String entityId,
  ) : this._internal(
          () => EntityDetail()..entityId = entityId,
          from: entityDetailProvider,
          name: r'entityDetailProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$entityDetailHash,
          dependencies: EntityDetailFamily._dependencies,
          allTransitiveDependencies:
              EntityDetailFamily._allTransitiveDependencies,
          entityId: entityId,
        );

  EntityDetailProvider._internal(
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
  FutureOr<Entity> runNotifierBuild(
    covariant EntityDetail notifier,
  ) {
    return notifier.build(
      entityId,
    );
  }

  @override
  Override overrideWith(EntityDetail Function() create) {
    return ProviderOverride(
      origin: this,
      override: EntityDetailProvider._internal(
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
  AutoDisposeAsyncNotifierProviderElement<EntityDetail, Entity>
      createElement() {
    return _EntityDetailProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is EntityDetailProvider && other.entityId == entityId;
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
mixin EntityDetailRef on AutoDisposeAsyncNotifierProviderRef<Entity> {
  /// The parameter `entityId` of this provider.
  String get entityId;
}

class _EntityDetailProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<EntityDetail, Entity>
    with EntityDetailRef {
  _EntityDetailProviderElement(super.provider);

  @override
  String get entityId => (origin as EntityDetailProvider).entityId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
