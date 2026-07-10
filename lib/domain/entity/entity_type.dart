enum EntityType {
  character,
  faction,
  raceCulture,
  location,
  powerMagicSystem,
  itemArtifact,
  event,
  conceptGlossary;

  String get key => name;

  String get label {
    switch (this) {
      case EntityType.character:
        return 'Character';
      case EntityType.faction:
        return 'Faction';
      case EntityType.raceCulture:
        return 'Race / Culture';
      case EntityType.location:
        return 'Location';
      case EntityType.powerMagicSystem:
        return 'Power / Magic System';
      case EntityType.itemArtifact:
        return 'Item / Artifact';
      case EntityType.event:
        return 'Event';
      case EntityType.conceptGlossary:
        return 'Concept / Glossary';
    }
  }

  static EntityType fromKey(String key) {
    return EntityType.values.firstWhere(
      (e) => e.name == key,
      orElse: () => throw ArgumentError('Unknown EntityType key: $key'),
    );
  }
}
