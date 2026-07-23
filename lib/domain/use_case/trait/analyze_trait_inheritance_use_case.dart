import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/trait/trait_inheritance.dart';

class AnalyzeTraitInheritanceParams {
  final List<Entity> characters;
  final List<Relationship> relationships;

  const AnalyzeTraitInheritanceParams({
    required this.characters,
    required this.relationships,
  });
}

@lazySingleton
class AnalyzeTraitInheritanceUseCase {
  static const _badgeColors = [
    0xFFD4A44C,
    0xFF6B8FA3,
    0xFFA78BFA,
    0xFF34D399,
    0xFFF87171,
    0xFFFBBF24,
    0xFF60A5FA,
    0xFFF472B6,
  ];

  Future<Either<Failure, List<TraitInheritance>>> call(
    AnalyzeTraitInheritanceParams params,
  ) async {
    try {
      final results = _analyze(params.characters, params.relationships);
      return Right(results);
    } on Exception catch (e) {
      return Left(Failure.unexpected(
        message: 'Failed to analyze trait inheritance: $e',
        originalError: e,
      ));
    }
  }

  List<TraitInheritance> _analyze(
    List<Entity> characters,
    List<Relationship> relationships,
  ) {
    final Map<String, List<String>> childToParents = {};
    for (final rel in relationships) {
      if (rel.typeKey == 'parent_of') {
        childToParents.putIfAbsent(rel.targetId, () => []);
        childToParents[rel.targetId]!.add(rel.sourceId);
      } else if (rel.typeKey == 'child_of') {
        childToParents.putIfAbsent(rel.sourceId, () => []);
        childToParents[rel.sourceId]!.add(rel.targetId);
      }
    }

    final Map<String, Entity> entityMap = {
      for (final e in characters) e.id: e,
    };

    final Map<String, int> traitColorMap = {};
    int nextColorIndex = 0;
    final List<TraitInheritance> results = [];

    for (final character in characters) {
      if (character.type != EntityType.character) continue;

      for (final field in character.customFields) {
        final value = field.value?.toString() ?? '';
        if (value.isEmpty) continue;

        final traitKey = field.key;
        final traitLabel = field.label;
        final parentIds = childToParents[character.id] ?? [];
        final inheritedFromIds = <String>[];
        final inheritedFromNames = <String>[];

        for (final parentId in parentIds) {
          final parent = entityMap[parentId];
          if (parent == null) continue;

          for (final pField in parent.customFields) {
            if (pField.key == traitKey) {
              final pValue = pField.value?.toString() ?? '';
              if (pValue.isNotEmpty) {
                inheritedFromIds.add(parentId);
                inheritedFromNames.add(parent.name);
                break;
              }
            }
          }
        }

        final colorIndex = traitColorMap.putIfAbsent(
          traitKey,
          () => nextColorIndex++,
        );

        results.add(TraitInheritance(
          traitKey: traitKey,
          traitLabel: traitLabel,
          traitValue: value,
          entityId: character.id,
          entityName: character.name,
          inheritedFromIds: inheritedFromIds,
          inheritedFromNames: inheritedFromNames,
          isInherited: inheritedFromIds.isNotEmpty,
          colorIndex: colorIndex % _badgeColors.length,
        ));
      }
    }

    return results;
  }

  static int badgeColor(int colorIndex) {
    return _badgeColors[colorIndex % _badgeColors.length];
  }
}
