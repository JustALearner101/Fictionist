enum EntityStatus {
  draft,
  canon,
  archived,
  deprecated;

  String get key => name;

  String get label {
    switch (this) {
      case EntityStatus.draft:
        return 'Draft';
      case EntityStatus.canon:
        return 'Canon';
      case EntityStatus.archived:
        return 'Archived';
      case EntityStatus.deprecated:
        return 'Deprecated';
    }
  }

  static EntityStatus fromKey(String key) {
    return EntityStatus.values.firstWhere(
      (e) => e.name == key,
      orElse: () => EntityStatus.draft,
    );
  }
}
