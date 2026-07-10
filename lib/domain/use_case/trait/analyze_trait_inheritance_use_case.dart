import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';

import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/core/use_case/use_case.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/trait/trait_inheritance.dart';

/// Parameters for analyzing trait inheritance within a family tree.
class AnalyzeTraitInheritanceParams {
  /// All characters to analyze.
  final List<Entity> characters;

  /// All parent-child relationships among those characters.
  final List<Relationship> relationships;

  const AnalyzeTraitInheritanceParams({
    required this.characters,
    required this.relationships,
  });
}

/// Analyzes custom field traits across a family tree to determine
/// which traits are inherited from ancestors.
///
/// Only considers [EntityType.character] entities and relationships
/// of type `parent_of` / `child_of`.
@lazySingleton
class AnalyzeTraitInheritanceUseCase
    implements UseCase<List<TraitInheritance>, AnalyzeTraitInheritanceParams> {
  // Trait badge colors — a curated palette
  static const _badgeColors = [
    0xFFD4A44C, // Gold
    0xFF6B8FA3, // Steel Blue
    0xFFA78BFA, // Amethyst
    0xFF34D399, // Emerald
    0xFFF87171, // Rose
    0xFFFBBF24, // Amber
    0xFF60A5FA, // Sky
    0xFFF472B6, // Pink
  ];

  @override
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
    // Build a map: child ID → list of parent IDs
    final Map<String, List<String>> childToParents = {};
    for (final rel in relationships) {
      if (rel.typeKey == 'parent_of') {
        // source = parent, target = child
        childToParents.putIfAbsent(rel.targetId, () => []);
        childToParents[rel.targetId]!.add(rel.sourceId);
      } else if (rel.typeKey == 'child_of') {
        // source = child, target = parent
        childToParents.putIfAbsent(rel.sourceId, () => []);
        childToParents[rel.sourceId]!.add(rel.targetId);
      }
    }

    // Build a lookup: entity ID → Entity
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

        // Determine if this trait is inheritable
        // (has a value that could be passed down)
        final traitKey = field.key;
        final traitLabel = field.label;

        // Find if any parent carries the same trait
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

        // Assign a color index per unique trait key
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

  /// Returns the badge color for a given color index.
  static int badgeColor(int colorIndex) {
    return _badgeColors[colorIndex % _badgeColors.length];
  }
}
