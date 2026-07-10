import 'package:fpdart/fpdart.dart';
import 'package:injectable/injectable.dart';
import 'package:uuid/uuid.dart';
import '../../../core/error/failure.dart';
import '../../../core/use_case/use_case.dart';
import '../../entity/custom_field.dart';
import '../../entity/entity_type.dart';
import '../../repository/template_repository.dart';
import '../../template/template.dart';

CustomField _field(String key, String label,
        {dynamic value = '', String fieldType = 'text'}) =>
    CustomField(
      id: const Uuid().v4(),
      key: key,
      label: label,
      fieldType: fieldType,
      value: value,
    );

@lazySingleton
class BootstrapUseCase implements UseCaseNoParams<Unit> {
  final TemplateRepository _templateRepository;

  BootstrapUseCase(this._templateRepository);

  @override
  Future<Either<Failure, Unit>> call() async {
    final templatesResult = await _templateRepository.getAllTemplates();
    return templatesResult.fold(
      (failure) => Left(failure),
      (existing) async {
        if (existing.isNotEmpty) {
          return const Right(unit);
        }

        final builtIns = [
          Template(
            id: 'template_character',
            name: 'Character Template',
            entityType: EntityType.character,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('age', 'Age'),
              _field('alignment', 'Alignment'),
              _field('occupation', 'Occupation/Role'),
              _field('backstory', 'Backstory Snippet'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_faction',
            name: 'Faction Template',
            entityType: EntityType.faction,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('leader', 'Leader'),
              _field('headquarters', 'Headquarters'),
              _field('influence', 'Influence Level'),
              _field('creed', 'Motto/Creed'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_location',
            name: 'Location Template',
            entityType: EntityType.location,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('climate', 'Climate'),
              _field('terrain', 'Terrain'),
              _field('population', 'Population'),
              _field('safety', 'Safety Level'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_item',
            name: 'Item Template',
            entityType: EntityType.itemArtifact,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('material', 'Material'),
              _field('rarity', 'Rarity'),
              _field('powers', 'Magical Properties'),
              _field('creator', 'Creator'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_event',
            name: 'Event Template',
            entityType: EntityType.event,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('significance', 'Significance'),
              _field('figures', 'Key Figures'),
              _field('outcome', 'Outcome'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_magic_system',
            name: 'Magic System Template',
            entityType: EntityType.powerMagicSystem,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('limitations', 'Rules of Limitation'),
              _field('source', 'Source of Power'),
              _field('cost', 'Cost of Usage'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_lore',
            name: 'Lore Template',
            entityType: EntityType.conceptGlossary,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('era', 'Historical Era'),
              _field('reliability', 'Reliability'),
              _field('origin', 'Origin'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
          Template(
            id: 'template_group',
            name: 'Group Template',
            entityType: EntityType.faction,
            isBuiltIn: true,
            customFieldsSchema: [
              _field('purpose', 'Purpose'),
              _field('criteria', 'Membership Criteria'),
              _field('status', 'Active Status'),
            ],
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        ];

        for (final template in builtIns) {
          final createRes = await _templateRepository.create(template);
          if (createRes.isLeft()) {
            return Left(Failure.database(
              message:
                  'Failed to populate default templates during app bootstrap',
            ));
          }
        }

        return const Right(unit);
      },
    );
  }
}
