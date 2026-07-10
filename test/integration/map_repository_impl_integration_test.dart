import 'package:fictionist/data/dao/map_dao.dart';
import 'package:fictionist/data/database/app_database.dart';
import 'package:fictionist/data/repository/map_repository_impl.dart';
import 'package:fictionist/domain/map/world_map.dart';
import 'package:fictionist/domain/map/map_pin.dart';
import 'package:flutter_test/flutter_test.dart';
import '../helpers/test_database.dart';

int _counter = 0;

WorldMap makeMap({String? id, String name = 'Test Map', String imagePath = 'assets/maps/test.png'}) {
  return WorldMap(
    id: id ?? 'map-${DateTime.now().microsecondsSinceEpoch}-${++_counter}',
    name: name,
    imagePath: imagePath,
  );
}

MapPin makePin({
  String? id,
  required String mapId,
  String entityId = 'entity-1',
  double xPercent = 0.5,
  double yPercent = 0.5,
  String? label,
}) {
  return MapPin(
    id: id ?? 'pin-${DateTime.now().microsecondsSinceEpoch}-${++_counter}',
    mapId: mapId,
    entityId: entityId,
    xPercent: xPercent,
    yPercent: yPercent,
    label: label,
  );
}

void main() {
  late AppDatabase db;
  late MapDao dao;
  late MapRepositoryImpl repository;

  setUp(() async {
    db = createTestDatabase();
    dao = db.mapDao;
    repository = MapRepositoryImpl(dao);
  });

  tearDown(() async => db.close());

  group('MapRepositoryImpl (integration)', () {
    group('createMap', () {
      test('should persist map and retrieve by id', () async {
        final map = makeMap(name: 'Middle-earth');
        final result = await repository.createMap(map);
        expect(result.isRight(), isTrue);

        final retrieved = await repository.getMapById(map.id);
        retrieved.fold(
          (_) => fail('map should exist'),
          (m) {
            expect(m.name, 'Middle-earth');
            expect(m.imagePath, 'assets/maps/test.png');
          },
        );
      });

      test('should persist multiple maps', () async {
        await repository.createMap(makeMap(name: 'Map A'));
        await repository.createMap(makeMap(name: 'Map B'));

        final all = await repository.getAllMaps();
        all.fold(
          (_) => fail('should succeed'),
          (maps) => expect(maps.length, 2),
        );
      });
    });

    group('getMapById', () {
      test('should return failure for non-existent map', () async {
        final result = await repository.getMapById('no-such');
        expect(result.isLeft(), isTrue);
      });
    });

    group('getAllMaps', () {
      test('should return empty list when no maps exist', () async {
        final result = await repository.getAllMaps();
        result.fold(
          (_) => fail('should succeed'),
          (maps) => expect(maps, isEmpty),
        );
      });
    });

    group('deleteMap', () {
      test('should hard-delete map', () async {
        final map = makeMap(name: 'Temp Map');
        await repository.createMap(map);

        await repository.deleteMap(map.id);

        final result = await repository.getMapById(map.id);
        expect(result.isLeft(), isTrue);
      });
    });

    group('pins', () {
      setUp(() async {
        // Pins reference entities via FK — create a dummy entity
        await db.customStatement(
          "INSERT INTO entities (id, name, entity_type, icon_color, created_at, updated_at) "
          "VALUES ('entity-1', 'Dummy', 'character', 0, '2025-01-01', '2025-01-01')",
        );
      });

      test('should create pin and retrieve for map', () async {
        final map = makeMap(name: 'World');
        await repository.createMap(map);

        final pin = makePin(mapId: map.id, label: 'Rivendell', xPercent: 0.3, yPercent: 0.7);
        await repository.createPin(pin);

        final pins = await repository.getPinsForMap(map.id);
        pins.fold(
          (_) => fail('should succeed'),
          (list) {
            expect(list.length, 1);
            expect(list.first.label, 'Rivendell');
            expect(list.first.xPercent, 0.3);
            expect(list.first.yPercent, 0.7);
          },
        );
      });

      test('should delete pin', () async {
        final map = makeMap(name: 'World');
        await repository.createMap(map);

        final pin = makePin(mapId: map.id, label: 'Remove me');
        await repository.createPin(pin);

        await repository.deletePin(pin.id);

        final pins = await repository.getPinsForMap(map.id);
        pins.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });

      test('should return empty pins for map with no pins', () async {
        final map = makeMap(name: 'Empty Map');
        await repository.createMap(map);

        final pins = await repository.getPinsForMap(map.id);
        pins.fold(
          (_) => fail('should succeed'),
          (list) => expect(list, isEmpty),
        );
      });
    });
  });
}
