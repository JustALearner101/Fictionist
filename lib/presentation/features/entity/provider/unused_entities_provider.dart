import 'package:riverpod_annotation/riverpod_annotation.dart';
import '../../../../domain/entity/entity.dart';
import '../../../../domain/use_case/entity/list_entities_use_case.dart';
import '../../../../domain/use_case/manuscript/manuscript_use_cases.dart';
import '../../../../injection.dart';

part 'unused_entities_provider.g.dart';

@riverpod
Future<UnusedEntitiesReport> unusedEntitiesReport(
  UnusedEntitiesReportRef ref,
) async {
  final entitiesUseCase = getIt<ListEntitiesUseCase>();
  final chaptersUseCase = getIt<ListChaptersUseCase>();

  final entitiesResult = await entitiesUseCase(const ListEntitiesParams());
  if (entitiesResult.isLeft()) {
    throw Exception('Failed to load entities');
  }
  final entities = entitiesResult.getOrElse((_) => <Entity>[]);

  final chaptersResult = await chaptersUseCase();
  final allText = StringBuffer();
  chaptersResult.fold(
    (_) {},
    (chapters) {
      for (final ch in chapters) {
        allText.write(ch.content);
        allText.write(' ');
      }
    },
  );

  final fullText = allText.toString().toLowerCase();
  final used = <Entity>[];
  final unused = <Entity>[];

  for (final entity in entities) {
    if (entity.name.length < 3) {
      used.add(entity); // too short to match reliably, consider used
      continue;
    }
    if (fullText.contains(entity.name.toLowerCase())) {
      used.add(entity);
    } else {
      unused.add(entity);
    }
  }

  return UnusedEntitiesReport(
    total: entities.length,
    used: used,
    unused: unused,
  );
}

class UnusedEntitiesReport {
  final int total;
  final List<Entity> used;
  final List<Entity> unused;

  const UnusedEntitiesReport({
    required this.total,
    required this.used,
    required this.unused,
  });
}
