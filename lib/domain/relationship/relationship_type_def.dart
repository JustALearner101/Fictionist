import '../entity/entity_type.dart';

class RelationshipTypeDef {
  final String key;
  final String label;
  final String? inverseLabel;
  final Set<EntityType> applicableSourceTypes;
  final Set<EntityType> applicableTargetTypes;
  final bool isBidirectional;

  const RelationshipTypeDef({
    required this.key,
    required this.label,
    this.inverseLabel,
    required this.applicableSourceTypes,
    required this.applicableTargetTypes,
    required this.isBidirectional,
  });
}
