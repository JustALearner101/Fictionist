import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/core/use_case/use_case.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_status.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';

class ContinuityCheckResult {
  final List<ContinuityViolation> violations;
  bool get isClean => violations.isEmpty;

  const ContinuityCheckResult({required this.violations});
}

class ContinuityViolation {
  final String message;
  final String severity; // 'error' | 'warning'
  final String? fixSuggestion;

  const ContinuityViolation({
    required this.message,
    this.severity = 'error',
    this.fixSuggestion,
  });
}

class ContinuityCheckParams {
  final List<Entity> entities;
  final List<Relationship> relationships;
  final List<TimelineEntry> timelineEntries;

  const ContinuityCheckParams({
    required this.entities,
    required this.relationships,
    required this.timelineEntries,
  });
}

@lazySingleton
class ContinuityCheckUseCase
    implements UseCase<ContinuityCheckResult, ContinuityCheckParams> {
  @override
  Future<Either<Failure, ContinuityCheckResult>> call(
    ContinuityCheckParams params,
  ) async {
    final violations = <ContinuityViolation>[];

    // Rule 1: Life Bounds — events outside character lifespan
    _checkLifeBounds(params, violations);

    // Rule 2: Faction Activity — characters in factions outside era span
    _checkFactionActivity(params, violations);

    // Rule 3: Orphan timeline entries (no linked entity)
    _checkOrphanEntries(params, violations);

    return Right(ContinuityCheckResult(violations: violations));
  }

  void _checkLifeBounds(
    ContinuityCheckParams params,
    List<ContinuityViolation> violations,
  ) {
    for (final entity in params.entities) {
      if (entity.status == EntityStatus.deprecated) continue;

      // Find birth/death from custom fields
      String? birthDate;
      String? deathDate;
      for (final field in entity.customFields) {
        final key = field.key.toLowerCase();
        final val = field.value?.toString() ?? '';
        if ((key.contains('birth') || key.contains('born')) &&
            val.isNotEmpty) {
          birthDate = val;
        }
        if ((key.contains('death') || key.contains('died')) &&
            val.isNotEmpty) {
          deathDate = val;
        }
      }

      if (birthDate == null && deathDate == null) continue;

      // Check timeline entries for this entity
      for (final entry in params.timelineEntries) {
        if (entry.entityId != entity.id) continue;
        final eventDate = entry.dateLabel;
        if (eventDate == null || eventDate.isEmpty) continue;

        if (deathDate != null && eventDate.compareTo(deathDate) > 0) {
          violations.add(ContinuityViolation(
            message:
                'Event "${entry.title}" (${entry.dateLabel}) occurs after '
                '${entity.name}\'s death (${deathDate}).',
            severity: 'error',
            fixSuggestion:
                'Change event date to before $deathDate or update '
                'death date for ${entity.name}.',
          ));
        }
      }
    }
  }

  void _checkFactionActivity(
    ContinuityCheckParams params,
    List<ContinuityViolation> violations,
  ) {
    for (final rel in params.relationships) {
      if (rel.typeKey != 'member_of') continue;

      // Check if the faction has an era span
      final faction = params.entities
          .where((e) => e.id == rel.targetId)
          .firstOrNull;
      if (faction == null) continue;

      String? factionStart;
      String? factionEnd;
      for (final field in faction.customFields) {
        final key = field.key.toLowerCase();
        final val = field.value?.toString() ?? '';
        if ((key.contains('founded') || key.contains('formed')) &&
            val.isNotEmpty) {
          factionStart = val;
        }
        if ((key.contains('dissolved') || key.contains('ended')) &&
            val.isNotEmpty) {
          factionEnd = val;
        }
      }

      if (factionStart == null && factionEnd == null) continue;

      final member = params.entities
          .where((e) => e.id == rel.sourceId)
          .firstOrNull;
      if (member == null) continue;

      // Find member's birth/death
      String? memberBirth;
      for (final field in member.customFields) {
        if (field.key.toLowerCase().contains('birth') &&
            (field.value?.toString() ?? '').isNotEmpty) {
          memberBirth = field.value.toString();
        }
      }

      if (factionStart != null &&
          memberBirth != null &&
          memberBirth.compareTo(factionStart) < 0) {
        violations.add(ContinuityViolation(
          message:
              '${member.name} was born ($memberBirth) before '
              '${faction.name} was formed ($factionStart) but is a member.',
          severity: 'warning',
          fixSuggestion:
              'Adjust birth date or faction founding date.',
        ));
      }
    }
  }

  void _checkOrphanEntries(
    ContinuityCheckParams params,
    List<ContinuityViolation> violations,
  ) {
    for (final entry in params.timelineEntries) {
      if (entry.entityId == null) continue;
      final exists = params.entities
          .any((e) => e.id == entry.entityId);
      if (!exists) {
        violations.add(ContinuityViolation(
          message:
              'Timeline entry "${entry.title}" references a deleted '
              'or missing entity.',
          severity: 'warning',
          fixSuggestion: 'Remove this entry or link it to an existing entity.',
        ));
      }
    }
  }
}
