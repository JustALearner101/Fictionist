import 'package:uuid/uuid.dart';
import '../../domain/entity/custom_field.dart';
import '../../domain/entity/entity.dart';
import '../../domain/entity/entity_status.dart';
import '../../domain/entity/entity_type.dart';
import '../../domain/relationship/relationship.dart';
import '../../domain/timeline/timeline_entry.dart';
import '../../domain/manuscript/manuscript_chapter.dart';
import '../../domain/plot/plot_card.dart';
import '../../domain/map/world_map.dart';
import '../../domain/map/map_pin.dart';

class SampleWorldData {
  static const uuid = Uuid();

  static Map<String, dynamic> generate() {
    final now = DateTime.now();

    // 1. Generate Entity IDs
    final elidorId = uuid.v4();
    final lyraId = uuid.v4();
    final aethelgardId = uuid.v4();
    final geniusId = uuid.v4();
    final covenId = uuid.v4();
    final vanguardId = uuid.v4();
    final scaniansId = uuid.v4();
    final elvesId = uuid.v4();
    final scaniaId = uuid.v4();
    final citadelId = uuid.v4();
    final cavernsId = uuid.v4();
    final amuletId = uuid.v4();
    final hourglassId = uuid.v4();
    final bladeId = uuid.v4();
    final runicId = uuid.v4();
    final chronoid = uuid.v4();
    final aetherId = uuid.v4();
    final exileId = uuid.v4();
    final convergenceId = uuid.v4();
    final treatyId = uuid.v4();
    final shiftId = uuid.v4();
    final bleedId = uuid.v4();

    // 2. Map IDs (for maps)
    final mapId = uuid.v4();

    final entities = [
      // === Characters ===
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
        id: lyraId,
        name: 'Lady Lyra',
        type: EntityType.character,
        status: EntityStatus.canon,
        description:
            'High Priestess of the Whispering Coven who guards the ancient runic relics in the Crystalline Caverns.',
        iconColor: 0xFFEC4899,
        customFields: [
          const CustomField(
            id: 'lyra-age',
            key: 'age',
            label: 'Age',
            fieldType: 'short_text',
            value: '87 years',
            sortOrder: 0,
          ),
          const CustomField(
            id: 'lyra-title',
            key: 'title',
            label: 'Title',
            fieldType: 'short_text',
            value: 'High Priestess',
            sortOrder: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: aethelgardId,
        name: 'Aethelgard the Eternal',
        type: EntityType.character,
        status: EntityStatus.draft,
        description:
            'The stoic commander of the Royal Vanguard, dedicated to preserving order across the realm.',
        iconColor: 0xFF10B981,
        customFields: [
          const CustomField(
            id: 'aethelgard-age',
            key: 'age',
            label: 'Age',
            fieldType: 'short_text',
            value: 'Unknown',
            sortOrder: 0,
          ),
          const CustomField(
            id: 'aethelgard-rank',
            key: 'rank',
            label: 'Military Rank',
            fieldType: 'short_text',
            value: 'Grand Commander',
            sortOrder: 1,
          ),
        ],
        createdAt: now,
        updatedAt: now,
      ),

      // === Factions ===
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
        id: covenId,
        name: 'The Whispering Coven',
        type: EntityType.faction,
        status: EntityStatus.canon,
        description:
            'A secretive circle of magic practitioners seeking to exploit timeline shifts to rewrite historical wars.',
        iconColor: 0xFF8B5CF6,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: vanguardId,
        name: 'Royal Vanguard',
        type: EntityType.faction,
        status: EntityStatus.canon,
        description:
            'The official military order sworn to protect the Shimmering Citadel and defend the realm against chronal threats.',
        iconColor: 0xFF3B82F6,
        createdAt: now,
        updatedAt: now,
      ),

      // === Race / Culture ===
      Entity(
        id: scaniansId,
        name: 'Scanians',
        type: EntityType.raceCulture,
        status: EntityStatus.canon,
        description:
            'The indigenous human tribes of the Scania Valley, who possess a natural affinity for runic attunement.',
        iconColor: 0xFFD97706,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: elvesId,
        name: 'Aether Elves',
        type: EntityType.raceCulture,
        status: EntityStatus.canon,
        description:
            'An long-lived elven lineage inhabiting the high ridges, capable of channeling raw temporal energy.',
        iconColor: 0xFF10B981,
        createdAt: now,
        updatedAt: now,
      ),

      // === Locations ===
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
        id: citadelId,
        name: 'The Shimmering Citadel',
        type: EntityType.location,
        status: EntityStatus.canon,
        description:
            'The capital city of the kingdom and the central headquarters of both the Royal Vanguard and Genius Society.',
        iconColor: 0xFFF59E0B,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: cavernsId,
        name: 'Crystalline Caverns',
        type: EntityType.location,
        status: EntityStatus.canon,
        description:
            'A massive underground network of glowing crystals that amplify chronal resonance.',
        iconColor: 0xFFEC4899,
        createdAt: now,
        updatedAt: now,
      ),

      // === Power / Magic Systems ===
      Entity(
        id: runicId,
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
        id: chronoid,
        name: 'Chrono-mancy',
        type: EntityType.powerMagicSystem,
        status: EntityStatus.canon,
        description:
            'The forbidden school of magic that enables manipulation of time streams, speed, and timeline echoes.',
        iconColor: 0xFF6366F1,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: aetherId,
        name: 'Aether Manipulation',
        type: EntityType.powerMagicSystem,
        status: EntityStatus.canon,
        description:
            'The physical channeling of raw, non-temporal cosmic magic into constructs, barriers, or energy strikes.',
        iconColor: 0xFF14B8A6,
        createdAt: now,
        updatedAt: now,
      ),

      // === Items / Artifacts ===
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
        id: hourglassId,
        name: 'The Temporal Hourglass',
        type: EntityType.itemArtifact,
        status: EntityStatus.canon,
        description:
            'An ancient relic capable of rewinding small pockets of local space by up to ten minutes.',
        iconColor: 0xFF6366F1,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: bladeId,
        name: 'Aether Blade',
        type: EntityType.itemArtifact,
        status: EntityStatus.draft,
        description:
            'A sword forged from crystalline light, capable of cutting through magical shields and chronal barriers.',
        iconColor: 0xFF14B8A6,
        createdAt: now,
        updatedAt: now,
      ),

      // === Events ===
      Entity(
        id: exileId,
        name: 'The Great Exile',
        type: EntityType.event,
        status: EntityStatus.canon,
        description:
            'The historic gathering where the Genius Society exiled Elidor Thorne for his heretical research.',
        iconColor: 0xFFF43F5E,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: convergenceId,
        name: 'The Crystalline Convergence',
        type: EntityType.event,
        status: EntityStatus.canon,
        description:
            'A rare celestial event where the underground crystals resonated, nearly tearing the regional timeline apart.',
        iconColor: 0xFFEC4899,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: treatyId,
        name: 'The Treaty of Scania',
        type: EntityType.event,
        status: EntityStatus.canon,
        description:
            'The peace accord signed between the Royal Vanguard and the Scania Valley tribes in 290 FA.',
        iconColor: 0xFF10B981,
        createdAt: now,
        updatedAt: now,
      ),

      // === Concept / Glossary ===
      Entity(
        id: shiftId,
        name: 'Temporal Shift',
        type: EntityType.conceptGlossary,
        status: EntityStatus.canon,
        description:
            'The physical phenomenon of a timeline changing, causing memories to alter and objects to disappear or move.',
        iconColor: 0xFF3F83F8,
        createdAt: now,
        updatedAt: now,
      ),
      Entity(
        id: bleedId,
        name: 'The Void Bleed',
        type: EntityType.conceptGlossary,
        status: EntityStatus.draft,
        description:
            'The toxic energy residue left behind in areas where timelines have been violently rewritten.',
        iconColor: 0xFF9B1C1C,
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
        sourceId: elidorId,
        targetId: geniusId,
        typeKey: 'rival_of',
        description: 'Severely opposed after the exile trial',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: lyraId,
        targetId: covenId,
        typeKey: 'member_of',
        description: 'Leader and spiritual advisor',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: aethelgardId,
        targetId: vanguardId,
        typeKey: 'member_of',
        description: 'Grand Commander of the order',
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
        sourceId: hourglassId,
        targetId: citadelId,
        typeKey: 'located_in',
        description: 'Stored in the vault of the Genius Society',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: bladeId,
        targetId: aethelgardId,
        typeKey: 'owned_by',
        description: 'Passed down to Aethelgard through commanders',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: vanguardId,
        targetId: geniusId,
        typeKey: 'allied_with',
        description: 'Collaborate to protect the Shimmering Citadel',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: covenId,
        targetId: geniusId,
        typeKey: 'rival_of',
        description: 'Bitter enemies competing for relic control',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: elidorId,
        targetId: lyraId,
        typeKey: 'allied_with',
        description: 'Secret alliance to investigate timeline stability',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: exileId,
        targetId: citadelId,
        typeKey: 'occurred_at',
        description: 'Conducted in the grand forum hall',
        createdAt: now,
        updatedAt: now,
      ),
      Relationship(
        id: uuid.v4(),
        sourceId: convergenceId,
        targetId: cavernsId,
        typeKey: 'occurred_at',
        description: 'Occurred when crystals hit full energy peak',
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
      TimelineEntry(
        id: uuid.v4(),
        title: 'The Treaty of Scania',
        description: 'Peace accord resolves early border conflicts in Scania.',
        dateLabel: '290 FA',
        eraLabel: 'First Age',
        sortOrder: 500,
        entityId: treatyId,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final chapters = [
      ManuscriptChapter(
        id: uuid.v4(),
        title: "The Exile's Wake",
        content:
            "# The Exile's Wake\n\nElidor Thorne stepped into the biting wind of the Scania Valley. His exile from the Genius Society was final. Behind him, the gates of the Shimmering Citadel closed forever. But ahead of him lay the secret he had risked everything to find: the Scania Valley anomaly.",
        sortOrder: 1,
        dateLabel: '392 FA',
        eraLabel: 'First Age',
        synopsis: 'Elidor begins his exile in Scania Valley after being expelled.',
        povCharacterId: elidorId,
        locationId: scaniaId,
        status: ChapterStatus.done,
        createdAt: now,
        updatedAt: now,
      ),
      ManuscriptChapter(
        id: uuid.v4(),
        title: "The Amulet's Whisper",
        content:
            "# The Amulet's Whisper\n\nLady Lyra watched the outsider from the shadows of the Crystalline Caverns. In her hands, the Amulet of Scania pulsed with a faint golden light. She could hear the whispers of the timeline changing, but here, the runic magic kept her anchored.",
        sortOrder: 2,
        dateLabel: '02 SA',
        eraLabel: 'Second Age',
        synopsis: 'Lady Lyra observes Elidor and holds the Amulet.',
        povCharacterId: lyraId,
        locationId: cavernsId,
        status: ChapterStatus.revising,
        createdAt: now,
        updatedAt: now,
      ),
      ManuscriptChapter(
        id: uuid.v4(),
        title: "The Temporal Hourglass",
        content:
            "# The Temporal Hourglass\n\nDeep within the temple ruins, Elidor found it. The Temporal Hourglass, glowing with volatile chronal energy. If the Genius Society's temporal shift succeeded, this whole valley would cease to exist. He had to act now, using the Runic Anchoring magic.",
        sortOrder: 3,
        dateLabel: '03 SA',
        eraLabel: 'Second Age',
        synopsis: 'Elidor discovers the Hourglass and prepares to intervene.',
        povCharacterId: elidorId,
        locationId: citadelId,
        status: ChapterStatus.draft,
        createdAt: now,
        updatedAt: now,
      ),
    ];

    // Plot points (Cards & Connections)
    final plotCards = [
      PlotCard(
        id: uuid.v4(),
        title: "The Trial of Elidor",
        summary:
            "Elidor Thorne is put on trial by the Genius Society for heresy and investigation into forbidden chronomancy.",
        xPosition: 100.0,
        yPosition: 150.0,
        colorHex: 0xFFEF4444, // Red
        createdAt: now,
        updatedAt: now,
      ),
      PlotCard(
        id: uuid.v4(),
        title: "The Exile's Journey",
        summary:
            "Exiled and stripped of his titles, Elidor journeys to the mysterious Scania Valley.",
        xPosition: 300.0,
        yPosition: 150.0,
        colorHex: 0xFF3B82F6, // Blue
        createdAt: now,
        updatedAt: now,
      ),
      PlotCard(
        id: uuid.v4(),
        title: "Finding the Amulet",
        summary:
            "In the Scania Valley, Elidor meets Lady Lyra and discovers the Amulet of Scania.",
        xPosition: 500.0,
        yPosition: 150.0,
        colorHex: 0xFF10B981, // Green
        createdAt: now,
        updatedAt: now,
      ),
      PlotCard(
        id: uuid.v4(),
        title: "The Coven's Strike",
        summary:
            "The Whispering Coven attacks to seize the Amulet, intending to trigger the Temporal Shift.",
        xPosition: 300.0,
        yPosition: 350.0,
        colorHex: 0xFFF59E0B, // Yellow
        createdAt: now,
        updatedAt: now,
      ),
    ];

    final plotConnections = [
      PlotConnection(
        id: uuid.v4(),
        sourceId: plotCards[0].id,
        targetId: plotCards[1].id,
        label: "Leads to exile",
        createdAt: now,
      ),
      PlotConnection(
        id: uuid.v4(),
        sourceId: plotCards[1].id,
        targetId: plotCards[2].id,
        label: "Discovers target",
        createdAt: now,
      ),
      PlotConnection(
        id: uuid.v4(),
        sourceId: plotCards[2].id,
        targetId: plotCards[3].id,
        label: "Coven reacts",
        createdAt: now,
      ),
    ];

    // Map & Pins
    final maps = [
      WorldMap(
        id: mapId,
        name: "Scania Valley & Surroundings",
        imagePath: "world_maps/scania_valley_sample.png",
      ),
    ];

    final mapPins = [
      MapPin(
        id: uuid.v4(),
        mapId: mapId,
        entityId: scaniaId,
        xPercent: 45.0,
        yPercent: 55.0,
        label: "Scania Valley",
      ),
      MapPin(
        id: uuid.v4(),
        mapId: mapId,
        entityId: cavernsId,
        xPercent: 65.0,
        yPercent: 40.0,
        label: "Crystalline Caverns",
      ),
      MapPin(
        id: uuid.v4(),
        mapId: mapId,
        entityId: citadelId,
        xPercent: 20.0,
        yPercent: 30.0,
        label: "The Shimmering Citadel",
      ),
    ];

    return {
      'entities': entities,
      'relationships': relationships,
      'timelineEntries': timelineEntries,
      'chapters': chapters,
      'plotCards': plotCards,
      'plotConnections': plotConnections,
      'maps': maps,
      'mapPins': mapPins,
    };
  }
}
