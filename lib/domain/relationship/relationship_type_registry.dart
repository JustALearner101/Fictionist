import '../entity/entity_type.dart';
import 'relationship_type_def.dart';

class RelationshipTypeRegistry {
  static const List<RelationshipTypeDef> builtinTypes = [
    RelationshipTypeDef(
      key: 'parent_of',
      label: 'Parent of',
      inverseLabel: 'Child of',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'child_of',
      label: 'Child of',
      inverseLabel: 'Parent of',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'sibling_of',
      label: 'Sibling of',
      inverseLabel: 'Sibling of',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'ally_of',
      label: 'Ally of',
      inverseLabel: 'Ally of',
      applicableSourceTypes: {EntityType.character, EntityType.faction},
      applicableTargetTypes: {EntityType.character, EntityType.faction},
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'enemy_of',
      label: 'Enemy of',
      inverseLabel: 'Enemy of',
      applicableSourceTypes: {EntityType.character, EntityType.faction},
      applicableTargetTypes: {EntityType.character, EntityType.faction},
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'member_of',
      label: 'Member of',
      inverseLabel: 'Has member',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.faction, EntityType.raceCulture},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'leader_of',
      label: 'Leader of',
      inverseLabel: 'Led by',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {
        EntityType.faction,
        EntityType.raceCulture,
        EntityType.location
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'located_in',
      label: 'Located in',
      inverseLabel: 'Contains',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.itemArtifact,
        EntityType.event
      },
      applicableTargetTypes: {EntityType.location},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'wields',
      label: 'Wields',
      inverseLabel: 'Wielded by',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.itemArtifact, EntityType.powerMagicSystem},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'created_by',
      label: 'Created by',
      inverseLabel: 'Created',
      applicableSourceTypes: {
        EntityType.itemArtifact,
        EntityType.powerMagicSystem,
        EntityType.conceptGlossary
      },
      applicableTargetTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.raceCulture
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'belongs_to',
      label: 'Belongs to',
      inverseLabel: 'Owns',
      applicableSourceTypes: {EntityType.itemArtifact},
      applicableTargetTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.location
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'participates_in',
      label: 'Participates in',
      inverseLabel: 'Has participant',
      applicableSourceTypes: {EntityType.character, EntityType.faction},
      applicableTargetTypes: {EntityType.event},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'occurred_at',
      label: 'Occurred at',
      inverseLabel: 'Event site of',
      applicableSourceTypes: {EntityType.event},
      applicableTargetTypes: {EntityType.location},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'practices',
      label: 'Practices',
      inverseLabel: 'Practiced by',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.raceCulture,
        EntityType.faction
      },
      applicableTargetTypes: {
        EntityType.powerMagicSystem,
        EntityType.conceptGlossary
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'rival_of',
      label: 'Rival of',
      inverseLabel: 'Rival of',
      applicableSourceTypes: {EntityType.character, EntityType.faction},
      applicableTargetTypes: {EntityType.character, EntityType.faction},
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'married_to',
      label: 'Married to',
      inverseLabel: 'Married to',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'mentors',
      label: 'Mentors',
      inverseLabel: 'Mentored by',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'rules_over',
      label: 'Rules over',
      inverseLabel: 'Ruled by',
      applicableSourceTypes: {EntityType.character, EntityType.faction},
      applicableTargetTypes: {EntityType.location, EntityType.faction},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'worships',
      label: 'Worships',
      inverseLabel: 'Worshipped by',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.raceCulture,
        EntityType.faction
      },
      applicableTargetTypes: {EntityType.character, EntityType.conceptGlossary},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'related_to',
      label: 'Related to',
      inverseLabel: 'Related to',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.raceCulture,
        EntityType.location,
        EntityType.powerMagicSystem,
        EntityType.itemArtifact,
        EntityType.event,
        EntityType.conceptGlossary
      },
      applicableTargetTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.raceCulture,
        EntityType.location,
        EntityType.powerMagicSystem,
        EntityType.itemArtifact,
        EntityType.event,
        EntityType.conceptGlossary
      },
      isBidirectional: true,
    ),
    RelationshipTypeDef(
      key: 'led_by',
      label: 'Led by',
      inverseLabel: 'Leader of',
      applicableSourceTypes: {
        EntityType.faction,
        EntityType.raceCulture,
        EntityType.location
      },
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'has_member',
      label: 'Has member',
      inverseLabel: 'Member of',
      applicableSourceTypes: {EntityType.faction, EntityType.raceCulture},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'contains',
      label: 'Contains',
      inverseLabel: 'Located in',
      applicableSourceTypes: {EntityType.location},
      applicableTargetTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.itemArtifact,
        EntityType.event
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'creator_of',
      label: 'Creator of',
      inverseLabel: 'Created by',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.raceCulture
      },
      applicableTargetTypes: {
        EntityType.itemArtifact,
        EntityType.powerMagicSystem,
        EntityType.conceptGlossary
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'owns',
      label: 'Owns',
      inverseLabel: 'Belongs to',
      applicableSourceTypes: {
        EntityType.character,
        EntityType.faction,
        EntityType.location
      },
      applicableTargetTypes: {EntityType.itemArtifact},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'wielded_by',
      label: 'Wielded by',
      inverseLabel: 'Wields',
      applicableSourceTypes: {
        EntityType.itemArtifact,
        EntityType.powerMagicSystem
      },
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'has_participant',
      label: 'Has participant',
      inverseLabel: 'Participates in',
      applicableSourceTypes: {EntityType.event},
      applicableTargetTypes: {EntityType.character, EntityType.faction},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'event_site_of',
      label: 'Event site of',
      inverseLabel: 'Occurred at',
      applicableSourceTypes: {EntityType.location},
      applicableTargetTypes: {EntityType.event},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'practiced_by',
      label: 'Practiced by',
      inverseLabel: 'Practices',
      applicableSourceTypes: {
        EntityType.powerMagicSystem,
        EntityType.conceptGlossary
      },
      applicableTargetTypes: {
        EntityType.character,
        EntityType.raceCulture,
        EntityType.faction
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'ruled_by',
      label: 'Ruled by',
      inverseLabel: 'Rules over',
      applicableSourceTypes: {EntityType.location, EntityType.faction},
      applicableTargetTypes: {EntityType.character, EntityType.faction},
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'worshipped_by',
      label: 'Worshipped by',
      inverseLabel: 'Worships',
      applicableSourceTypes: {EntityType.character, EntityType.conceptGlossary},
      applicableTargetTypes: {
        EntityType.character,
        EntityType.raceCulture,
        EntityType.faction
      },
      isBidirectional: false,
    ),
    RelationshipTypeDef(
      key: 'mentored_by',
      label: 'Mentored by',
      inverseLabel: 'Mentors',
      applicableSourceTypes: {EntityType.character},
      applicableTargetTypes: {EntityType.character},
      isBidirectional: false,
    ),
  ];

  static RelationshipTypeDef? getDef(String key) {
    for (final def in builtinTypes) {
      if (def.key == key) return def;
    }
    return null;
  }

  static const Map<String, String> inverseRelationshipTypes = {
    'parent_of': 'child_of',
    'child_of': 'parent_of',
    'leader_of': 'led_by',
    'led_by': 'leader_of',
    'member_of': 'has_member',
    'has_member': 'member_of',
    'located_in': 'contains',
    'contains': 'located_in',
    'created_by': 'creator_of',
    'creator_of': 'created_by',
    'belongs_to': 'owns',
    'owns': 'belongs_to',
    'wields': 'wielded_by',
    'wielded_by': 'wields',
    'participates_in': 'has_participant',
    'has_participant': 'participates_in',
    'occurred_at': 'event_site_of',
    'event_site_of': 'occurred_at',
    'practices': 'practiced_by',
    'practiced_by': 'practices',
    'rules_over': 'ruled_by',
    'ruled_by': 'rules_over',
    'worships': 'worshipped_by',
    'worshipped_by': 'worships',
    'mentors': 'mentored_by',
    'mentored_by': 'mentors',
    // Symmetric types map to themselves
    'ally_of': 'ally_of',
    'enemy_of': 'enemy_of',
    'sibling_of': 'sibling_of',
    'rival_of': 'rival_of',
    'married_to': 'married_to',
    'related_to': 'related_to',
  };

  static String? getInverseKey(String key) {
    return inverseRelationshipTypes[key];
  }
}
