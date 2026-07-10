import 'package:uuid/uuid.dart';
import '../../domain/entity/custom_field.dart';
import '../../domain/entity/entity.dart';
import '../../domain/entity/entity_status.dart';
import '../../domain/entity/entity_type.dart';
import '../../domain/relationship/relationship.dart';
import '../../domain/timeline/timeline_entry.dart';

class SampleWorldData {
  static const uuid = Uuid();

  static Map<String, dynamic> generate() {
    final now = DateTime.now();

    // Generate IDs
    final elidorId = uuid.v4();
    final geniusId = uuid.v4();
    final scaniaId = uuid.v4();
    final amuletId = uuid.v4();
    final powerId = uuid.v4();
    final eventId = uuid.v4();

    final entities = [
      Entity(
        id: elidorId,
        name: 'Elidor Thorne',
        type: EntityType.character,
        status: EntityStatus.canon,
        description:
            'A high scholar of the Genius Society who was exiled for investigating the Scania Valley anomaly.',
        iconColor: 0xFFA78BFA,
        customFields: [
          const CustomField(
            id: 'elidor-age',
            key: 'age',
            label: 'Age',
            fieldType: 'short_text',
            value: '142 years',
            sortOrder: 0,
          ),
          const CustomField(
            id: 'elidor-title',
            key: 'title',
            label: 'Title',
            fieldType: 'short_text',
            value: 'Exiled High Scholar',
            sortOrder: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: geniusId,
        name: 'Genius Society',
        type: EntityType.faction,
        status: EntityStatus.canon,
        description:
            'An ancient order of scholars and mages dedicated to exploring anomalies and safeguarding canon historical timelines.',
        iconColor: 0xFFF59E0B,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: scaniaId,
        name: 'Scania Valley',
        type: EntityType.location,
        status: EntityStatus.draft,
        description:
            'A mysterious rift valley filled with runic anomalies and floating rock formations.',
        iconColor: 0xFF3B82F6,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: amuletId,
        name: 'Amulet of Scania',
        type: EntityType.itemArtifact,
        status: EntityStatus.canon,
        description:
            'A golden runic amulet found deep in the Scania Valley. Allows the wearer to anchor themselves against timeline alterations.',
        iconColor: 0xFFFBBF24,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: powerId,
        name: 'Runic Anchoring',
        type: EntityType.powerMagicSystem,
        status: EntityStatus.canon,
        description:
            'The art of tracing static runic structures on items or souls to make them immune to temporal shifting.',
        iconColor: 0xFFEF4444,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: eventId,
        name: 'The Great Exile',
        type: EntityType.event,
        status: EntityStatus.canon,
        description:
            'The historic gathering where the Genius Society exiled Elidor Thorne for his heretical research.',
        iconColor: 0xFFF43F5E,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final relationships = [
      Relationship(
        id: uuid.v4(),
        sourceId: elidorId,
        targetId: geniusId,
        typeKey: 'member_of',
        description: 'Exiled high scholar member',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: amuletId,
        targetId: scaniaId,
        typeKey: 'located_in',
        description: 'Discovered in a crystalline cave',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: elidorId,
        targetId: geniusId,
        typeKey: 'rival_of',
        description: 'Severely opposed after the exile trial',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: eventId,
        targetId: scaniaId,
        typeKey: 'occurred_at',
        description: 'Conducted in the valley temple ruins',
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final timelineEntries = [
      TimelineEntry(
        id: uuid.v4(),
        title: 'The Discovery of Scania Valley',
        description: 'Expeditions discover the runic anomalies in Scania.',
        dateLabel: '340 FA',
        eraLabel: 'First Age',
        sortOrder: 1000,
        entityId: scaniaId,
        createdAt: now,
        updatedAt: now,
      ),
      TimelineEntry(
        id: uuid.v4(),
        title: 'The Great Exile',
        description:
            'Elidor Thorne is officially expelled from the Genius Society.',
        dateLabel: '392 FA',
        eraLabel: 'First Age',
        sortOrder: 2000,
        entityId: elidorId,
        createdAt: now,
        updatedAt: now,
      ),
      TimelineEntry(
        id: uuid.v4(),
        title: 'Forge of the Amulet',
        description:
            'Wizards craft the Amulet of Scania using runic anchoring.',
        dateLabel: '02 SA',
        eraLabel: 'Second Age',
        sortOrder: 3000,
        entityId: amuletId,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    return {
      'entities': entities,
      'relationships': relationships,
      'timelineEntries': timelineEntries,
    };
  }
}
