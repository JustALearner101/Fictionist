// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'map_provider.dart';

// **************************************************************************
// RiverpodGenerator
// **************************************************************************

String _$absoluteMapImagePathHash() =>
    r'2b77b020eacbf7c4fba7b0397a37a6fb1a7098d5';

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

/// See also [absoluteMapImagePath].
@ProviderFor(absoluteMapImagePath)
const absoluteMapImagePathProvider = AbsoluteMapImagePathFamily();

/// See also [absoluteMapImagePath].
class AbsoluteMapImagePathFamily extends Family<AsyncValue<String>> {
  /// See also [absoluteMapImagePath].
  const AbsoluteMapImagePathFamily();

  /// See also [absoluteMapImagePath].
  AbsoluteMapImagePathProvider call(
    String relativePath,
  ) {
    return AbsoluteMapImagePathProvider(
      relativePath,
    );
  }

  @override
  AbsoluteMapImagePathProvider getProviderOverride(
    covariant AbsoluteMapImagePathProvider provider,
  ) {
    return call(
      provider.relativePath,
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
  String? get name => r'absoluteMapImagePathProvider';
}

/// See also [absoluteMapImagePath].
class AbsoluteMapImagePathProvider extends AutoDisposeFutureProvider<String> {
  /// See also [absoluteMapImagePath].
  AbsoluteMapImagePathProvider(
    String relativePath,
  ) : this._internal(
          (ref) => absoluteMapImagePath(
            ref as AbsoluteMapImagePathRef,
            relativePath,
          ),
          from: absoluteMapImagePathProvider,
          name: r'absoluteMapImagePathProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$absoluteMapImagePathHash,
          dependencies: AbsoluteMapImagePathFamily._dependencies,
          allTransitiveDependencies:
              AbsoluteMapImagePathFamily._allTransitiveDependencies,
          relativePath: relativePath,
        );

  AbsoluteMapImagePathProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.relativePath,
  }) : super.internal();

  final String relativePath;

  @override
  Override overrideWith(
    FutureOr<String> Function(AbsoluteMapImagePathRef provider) create,
  ) {
    return ProviderOverride(
      origin: this,
      override: AbsoluteMapImagePathProvider._internal(
        (ref) => create(ref as AbsoluteMapImagePathRef),
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        relativePath: relativePath,
      ),
    );
  }

  @override
  AutoDisposeFutureProviderElement<String> createElement() {
    return _AbsoluteMapImagePathProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is AbsoluteMapImagePathProvider &&
        other.relativePath == relativePath;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, relativePath.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin AbsoluteMapImagePathRef on AutoDisposeFutureProviderRef<String> {
  /// The parameter `relativePath` of this provider.
  String get relativePath;
}

class _AbsoluteMapImagePathProviderElement
    extends AutoDisposeFutureProviderElement<String>
    with AbsoluteMapImagePathRef {
  _AbsoluteMapImagePathProviderElement(super.provider);

  @override
  String get relativePath =>
      (origin as AbsoluteMapImagePathProvider).relativePath;
}

String _$worldMapListHash() => r'dad5e185cadbf3759ac122403c892dc172da3d30';

/// See also [WorldMapList].
@ProviderFor(WorldMapList)
final worldMapListProvider =
    AutoDisposeAsyncNotifierProvider<WorldMapList, List<WorldMap>>.internal(
  WorldMapList.new,
  name: r'worldMapListProvider',
  debugGetCreateSourceHash:
      const bool.fromEnvironment('dart.vm.product') ? null : _$worldMapListHash,
  dependencies: null,
  allTransitiveDependencies: null,
);

typedef _$WorldMapList = AutoDisposeAsyncNotifier<List<WorldMap>>;
String _$mapPinsHash() => r'd1a382c306d0456a843d932d82e840a89985f0a1';

abstract class _$MapPins
    extends BuildlessAutoDisposeAsyncNotifier<List<MapPin>> {
  late final String mapId;

  FutureOr<List<MapPin>> build(
    String mapId,
  );
}

/// See also [MapPins].
@ProviderFor(MapPins)
const mapPinsProvider = MapPinsFamily();

/// See also [MapPins].
class MapPinsFamily extends Family<AsyncValue<List<MapPin>>> {
  /// See also [MapPins].
  const MapPinsFamily();

  /// See also [MapPins].
  MapPinsProvider call(
    String mapId,
  ) {
    return MapPinsProvider(
      mapId,
    );
  }

  @override
  MapPinsProvider getProviderOverride(
    covariant MapPinsProvider provider,
  ) {
    return call(
      provider.mapId,
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
  String? get name => r'mapPinsProvider';
}

/// See also [MapPins].
class MapPinsProvider
    extends AutoDisposeAsyncNotifierProviderImpl<MapPins, List<MapPin>> {
  /// See also [MapPins].
  MapPinsProvider(
    String mapId,
  ) : this._internal(
          () => MapPins()..mapId = mapId,
          from: mapPinsProvider,
          name: r'mapPinsProvider',
          debugGetCreateSourceHash:
              const bool.fromEnvironment('dart.vm.product')
                  ? null
                  : _$mapPinsHash,
          dependencies: MapPinsFamily._dependencies,
          allTransitiveDependencies: MapPinsFamily._allTransitiveDependencies,
          mapId: mapId,
        );

  MapPinsProvider._internal(
    super._createNotifier, {
    required super.name,
    required super.dependencies,
    required super.allTransitiveDependencies,
    required super.debugGetCreateSourceHash,
    required super.from,
    required this.mapId,
  }) : super.internal();

  final String mapId;

  @override
  FutureOr<List<MapPin>> runNotifierBuild(
    covariant MapPins notifier,
  ) {
    return notifier.build(
      mapId,
    );
  }

  @override
  Override overrideWith(MapPins Function() create) {
    return ProviderOverride(
      origin: this,
      override: MapPinsProvider._internal(
        () => create()..mapId = mapId,
        from: from,
        name: null,
        dependencies: null,
        allTransitiveDependencies: null,
        debugGetCreateSourceHash: null,
        mapId: mapId,
      ),
    );
  }

  @override
  AutoDisposeAsyncNotifierProviderElement<MapPins, List<MapPin>>
      createElement() {
    return _MapPinsProviderElement(this);
  }

  @override
  bool operator ==(Object other) {
    return other is MapPinsProvider && other.mapId == mapId;
  }

  @override
  int get hashCode {
    var hash = _SystemHash.combine(0, runtimeType.hashCode);
    hash = _SystemHash.combine(hash, mapId.hashCode);

    return _SystemHash.finish(hash);
  }
}

@Deprecated('Will be removed in 3.0. Use Ref instead')
// ignore: unused_element
mixin MapPinsRef on AutoDisposeAsyncNotifierProviderRef<List<MapPin>> {
  /// The parameter `mapId` of this provider.
  String get mapId;
}

class _MapPinsProviderElement
    extends AutoDisposeAsyncNotifierProviderElement<MapPins, List<MapPin>>
    with MapPinsRef {
  _MapPinsProviderElement(super.provider);

  @override
  String get mapId => (origin as MapPinsProvider).mapId;
}
// ignore_for_file: type=lint
// ignore_for_file: subtype_of_sealed_class, invalid_use_of_internal_member, invalid_use_of_visible_for_testing_member, deprecated_member_use_from_same_package
