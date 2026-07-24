import 'package:drift/drift.dart';
import 'package:injectable/injectable.dart';
import '../database/app_database.dart';
import '../database/tables/projects_table.dart';
import '../database/tables/entity_table.dart';
import '../database/tables/tag_table.dart';
import '../database/tables/timeline_entry_table.dart';
import '../database/tables/world_map_table.dart';
import '../database/tables/manuscript_chapter_table.dart';
import '../database/tables/plot_tables.dart';
import '../database/tables/setup_payoff_table.dart';

part 'project_dao.g.dart';

@lazySingleton
@DriftAccessor(tables: [
  Projects,
  Entities,
  Tags,
  TimelineEntries,
  WorldMaps,
  ManuscriptChapters,
  PlotCards,
  SetupPayoffs,
])
class ProjectDao extends DatabaseAccessor<AppDatabase> with _$ProjectDaoMixin {
  ProjectDao(AppDatabase db) : super(db);

  Future<List<ProjectRow>> getAllProjects() {
    return (select(projects)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.lastAccessedAt)]))
        .get();
  }

  Future<ProjectRow?> getProjectById(String id) {
    return (select(projects)
          ..where((t) => t.id.equals(id) & t.isDeleted.equals(false)))
        .getSingleOrNull();
  }

  Future<ProjectRow?> getById(String id) => getProjectById(id);

  Future<ProjectRow?> getMostRecentlyAccessed() {
    return (select(projects)
          ..where((t) => t.isDeleted.equals(false))
          ..orderBy([(t) => OrderingTerm.desc(t.lastAccessedAt)])
          ..limit(1))
        .getSingleOrNull();
  }

  Future<int> insertProject(ProjectsCompanion companion) {
    return into(projects).insert(companion);
  }

  Future<bool> updateProject(ProjectsCompanion companion) {
    return (update(projects)..where((t) => t.id.equals(companion.id.value)))
        .write(companion)
        .then((count) => count > 0);
  }

  Future<int> deleteProject(String id) {
    return (delete(projects)..where((t) => t.id.equals(id))).go();
  }

  Future<int> touchLastAccessed(String id, DateTime timestamp) {
    return (update(projects)..where((t) => t.id.equals(id)))
        .write(ProjectsCompanion(
          lastAccessedAt: Value(timestamp),
          updatedAt: Value(timestamp),
        ));
  }
}
