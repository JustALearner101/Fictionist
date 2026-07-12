import 'dart:convert';
import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../../core/utils/sample_world_data.dart';
import '../../entity/entity.dart';
import '../../manuscript/manuscript_chapter.dart';
import '../../map/map_pin.dart';
import '../../map/world_map.dart';
import '../../plot/plot_card.dart';
import '../../relationship/relationship.dart';
import '../../repository/entity_repository.dart';
import '../../repository/entity_version_repository.dart';
import '../../repository/manuscript_repository.dart';
import '../../repository/map_repository.dart';
import '../../repository/plot_repository.dart';
import '../../repository/relationship_repository.dart';
import '../../repository/timeline_repository.dart';
import '../../timeline/timeline_entry.dart';
import '../../version/entity_version.dart';

@lazySingleton
class SampleWorldUseCase implements UseCaseNoParams<Unit> {
  final EntityRepository _entityRepo;
  final EntityVersionRepository _versionRepo;
  final RelationshipRepository _relationshipRepo;
  final TimelineRepository _timelineRepo;
  final ManuscriptRepository _manuscriptRepo;
  final MapRepository _mapRepo;
  final PlotRepository _plotRepo;

  SampleWorldUseCase(
    this._entityRepo,
    this._versionRepo,
    this._relationshipRepo,
    this._timelineRepo,
    this._manuscriptRepo,
    this._mapRepo,
    this._plotRepo,
  );

  @override
  Future<Either<Failure, Unit>> call() async {
    try {
      // 1. Generate data
      final data = SampleWorldData.generate();
      final entities = data['entities'] as List<Entity>;
      final relationships = data['relationships'] as List<Relationship>;
      final timelineEntries = data['timelineEntries'] as List<TimelineEntry>;
      final chapters = data['chapters'] as List<ManuscriptChapter>;
      final plotCards = data['plotCards'] as List<PlotCard>;
      final plotConnections = data['plotConnections'] as List<PlotConnection>;
      final maps = data['maps'] as List<WorldMap>;
      final mapPins = data['mapPins'] as List<MapPin>;

      // 2. Insert Entities and their initial versions
      for (final entity in entities) {
        final entResult = await _entityRepo.create(entity);
        if (entResult.isLeft()) {
          return Left(entResult.fold((l) => l, (r) => throw Exception()));
        }

        // Add version
        final version = EntityVersion(
          id: SampleWorldData.uuid.v4(),
          entityId: entity.id,
          snapshotJson: jsonEncode(entity.toJson()),
          changedAt: DateTime.now(),
          changeNote: 'Initial bootstrap snapshot',
        );

        final verResult = await _versionRepo.create(version);
        if (verResult.isLeft()) {
          return Left(verResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 3. Insert Relationships
      for (final rel in relationships) {
        final relResult = await _relationshipRepo.create(rel);
        if (relResult.isLeft()) {
          return Left(relResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 4. Insert Timeline Entries
      for (final entry in timelineEntries) {
        final timeResult = await _timelineRepo.create(entry);
        if (timeResult.isLeft()) {
          return Left(timeResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 5. Insert Manuscript Chapters
      for (final chapter in chapters) {
        final chResult = await _manuscriptRepo.create(chapter);
        if (chResult.isLeft()) {
          return Left(chResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      // 6. Insert Plot Points (Cards and Connections)
      final Map<String, String> cardIdMap = {};
      for (final card in plotCards) {
        final result = await _plotRepo.createCard(
          title: card.title,
          summary: card.summary,
          xPosition: card.xPosition,
          yPosition: card.yPosition,
          colorHex: card.colorHex,
        );
        if (result.isLeft()) {
          return Left(result.fold((l) => l, (r) => throw Exception()));
        }
        final createdCard = result.fold((l) => throw Exception(), (r) => r);
        cardIdMap[card.id] = createdCard.id;
      }

      for (final conn in plotConnections) {
        final newSourceId = cardIdMap[conn.sourceId];
        final newTargetId = cardIdMap[conn.targetId];
        if (newSourceId != null && newTargetId != null) {
          final result = await _plotRepo.createConnection(
            newSourceId,
            newTargetId,
            label: conn.label,
          );
          if (result.isLeft()) {
            return Left(result.fold((l) => l, (r) => throw Exception()));
          }
        }
      }

      // 7. Insert Maps and Map Pins
      for (final map in maps) {
        // Save the map image to disk first (1x1 pixel transparent PNG)
        final imageBytes = [
          137, 80, 78, 71, 13, 10, 26, 10, 0, 0, 0, 13, 73, 72, 68, 82, 0, 0, 0, 1, 0,
          0, 0, 1, 8, 6, 0, 0, 0, 31, 21, 196, 137, 0, 0, 0, 13, 73, 68, 65, 84, 120,
          156, 99, 96, 0, 0, 0, 2, 0, 1, 73, 175, 168, 116, 0, 0, 0, 0, 73, 69, 78, 68,
          174, 66, 96, 130,
        ];
        final saveImgResult = await _mapRepo.saveMapImage(map.imagePath, imageBytes);
        if (saveImgResult.isLeft()) {
          return Left(saveImgResult.fold((l) => l, (r) => throw Exception()));
        }

        final mapResult = await _mapRepo.createMap(map);
        if (mapResult.isLeft()) {
          return Left(mapResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      for (final pin in mapPins) {
        final pinResult = await _mapRepo.createPin(pin);
        if (pinResult.isLeft()) {
          return Left(pinResult.fold((l) => l, (r) => throw Exception()));
        }
      }

      return const Right(unit);
    } catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to complete sample world bootstrap: $e',
        originalError: e,
      ));
    }
  }
}
