/// The category of name to generate.
enum GenerationType {
  /// Personal names (e.g., Elven, Dwarven, Nordic, Fantasy).
  characterName,

  /// Faction/group titles (e.g., Iron Vanguard, Sun Covenant).
  factionName,

  /// Legendary item/artifact names (e.g., Soulbrand, Starcleaver).
  artifactName,

  /// Location/place names (e.g., Thornhaven, Embermoor).
  locationName,

  /// Legendary/epic titles (e.g., Soulbrand, The Unbroken).
  legendaryTitle;

  String get label {
    switch (this) {
      case GenerationType.characterName:
        return 'Character Name';
      case GenerationType.factionName:
        return 'Faction Title';
      case GenerationType.artifactName:
        return 'Artifact / Item';
      case GenerationType.locationName:
        return 'Location';
      case GenerationType.legendaryTitle:
        return 'Legendary Title';
    }
  }
}
