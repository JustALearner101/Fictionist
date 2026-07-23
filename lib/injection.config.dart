// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// InjectableConfigGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:fictionist/data/codex/codex_archive_service.dart' as _i835;
import 'package:fictionist/data/compiler/manuscript_compiler.dart' as _i522;
import 'package:fictionist/data/dao/entity_dao.dart' as _i573;
import 'package:fictionist/data/dao/entity_version_dao.dart' as _i983;
import 'package:fictionist/data/dao/manuscript_dao.dart' as _i25;
import 'package:fictionist/data/dao/map_dao.dart' as _i1004;
import 'package:fictionist/data/dao/plot_dao.dart' as _i476;
import 'package:fictionist/data/dao/relationship_dao.dart' as _i499;
import 'package:fictionist/data/dao/snapshot_dao.dart' as _i569;
import 'package:fictionist/data/dao/tag_dao.dart' as _i932;
import 'package:fictionist/data/dao/template_dao.dart' as _i573;
import 'package:fictionist/data/dao/timeline_dao.dart' as _i651;
import 'package:fictionist/data/database/app_database.dart' as _i92;
import 'package:fictionist/data/repository/entity_repository_impl.dart'
    as _i392;
import 'package:fictionist/data/repository/entity_version_repository_impl.dart'
    as _i1027;
import 'package:fictionist/data/repository/manuscript_repository_impl.dart'
    as _i456;
import 'package:fictionist/data/repository/map_repository_impl.dart' as _i625;
import 'package:fictionist/data/repository/name_generator_repository_impl.dart'
    as _i284;
import 'package:fictionist/data/repository/plot_repository.dart' as _i89;
import 'package:fictionist/data/repository/relationship_repository_impl.dart'
    as _i868;
import 'package:fictionist/data/repository/sync_repository_impl.dart' as _i313;
import 'package:fictionist/data/repository/tag_repository_impl.dart' as _i319;
import 'package:fictionist/data/repository/template_repository_impl.dart'
    as _i999;
import 'package:fictionist/data/repository/timeline_repository_impl.dart'
    as _i753;
import 'package:fictionist/domain/services/backup_synchronizer.dart' as _i925;
import 'package:fictionist/domain/use_case/bootstrap/bootstrap_use_case.dart'
    as _i791;
import 'package:fictionist/domain/use_case/bootstrap/sample_world_use_case.dart'
    as _i272;
import 'package:fictionist/domain/use_case/continuity_check_use_case.dart'
    as _i356;
import 'package:fictionist/domain/use_case/entity/create_entity_use_case.dart'
    as _i501;
import 'package:fictionist/domain/use_case/entity/delete_entity_use_case.dart'
    as _i998;
import 'package:fictionist/domain/use_case/entity/get_entity_references_use_case.dart'
    as _i483;
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart'
    as _i132;
import 'package:fictionist/domain/use_case/entity/update_entity_use_case.dart'
    as _i178;
import 'package:fictionist/domain/use_case/export/export_database_use_case.dart'
    as _i714;
import 'package:fictionist/domain/use_case/export/import_database_use_case.dart'
    as _i564;
import 'package:fictionist/domain/use_case/manuscript/manuscript_use_cases.dart'
    as _i608;
import 'package:fictionist/domain/use_case/name_generator/generate_names_use_case.dart'
    as _i802;
import 'package:fictionist/domain/use_case/relationship/create_relationship_use_case.dart'
    as _i664;
import 'package:fictionist/domain/use_case/sync/sync_backup_use_case.dart'
    as _i907;
import 'package:fictionist/domain/use_case/tag/assign_tag_use_case.dart'
    as _i885;
import 'package:fictionist/domain/use_case/tag/create_tag_use_case.dart'
    as _i417;
import 'package:fictionist/domain/use_case/timeline/create_timeline_entry_use_case.dart'
    as _i1060;
import 'package:fictionist/domain/use_case/timeline/reorder_timeline_use_case.dart'
    as _i780;
import 'package:fictionist/domain/use_case/trait/analyze_trait_inheritance_use_case.dart'
    as _i366;
import 'package:fictionist/domain/wikilink/wikilink_engine.dart' as _i397;
import 'package:get_it/get_it.dart' as _i174;
import 'package:injectable/injectable.dart' as _i526;

extension GetItInjectableX on _i174.GetIt {
// initializes the registration of main-scope dependencies inside of GetIt
  _i174.GetIt init({
    String? environment,
    _i526.EnvironmentFilter? environmentFilter,
  }) {
    final gh = _i526.GetItHelper(
      this,
      environment,
      environmentFilter,
    );
    gh.lazySingleton<_i835.CodexArchiveService>(
        () => _i835.CodexArchiveService());
    gh.lazySingleton<_i92.AppDatabase>(() => _i92.AppDatabase());
    gh.lazySingleton<_i284.NameGeneratorRepositoryImpl>(
        () => _i284.NameGeneratorRepositoryImpl());
    gh.lazySingleton<_i925.BackupSynchronizer>(
        () => _i925.BackupSynchronizer());
    gh.lazySingleton<_i356.ContinuityCheckUseCase>(
        () => _i356.ContinuityCheckUseCase());
    gh.lazySingleton<_i366.AnalyzeTraitInheritanceUseCase>(
        () => _i366.AnalyzeTraitInheritanceUseCase());
    gh.lazySingleton<_i397.WikilinkEngine>(() => _i397.WikilinkEngine());
    gh.lazySingleton<_i573.EntityDao>(
        () => _i573.EntityDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i983.EntityVersionDao>(
        () => _i983.EntityVersionDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i25.ManuscriptDao>(
        () => _i25.ManuscriptDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i1004.MapDao>(
        () => _i1004.MapDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i476.PlotDao>(
        () => _i476.PlotDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i499.RelationshipDao>(
        () => _i499.RelationshipDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i569.SnapshotDao>(
        () => _i569.SnapshotDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i932.TagDao>(() => _i932.TagDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i573.TemplateDao>(
        () => _i573.TemplateDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i651.TimelineDao>(
        () => _i651.TimelineDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i868.RelationshipRepositoryImpl>(
        () => _i868.RelationshipRepositoryImpl(gh<_i499.RelationshipDao>()));
    gh.lazySingleton<_i802.GenerateNamesUseCase>(() =>
        _i802.GenerateNamesUseCase(gh<_i284.NameGeneratorRepositoryImpl>()));
    gh.lazySingleton<_i664.CreateRelationshipUseCase>(() =>
        _i664.CreateRelationshipUseCase(
            gh<_i868.RelationshipRepositoryImpl>()));
    gh.lazySingleton<_i89.PlotRepositoryImpl>(
        () => _i89.PlotRepositoryImpl(gh<_i476.PlotDao>()));
    gh.lazySingleton<_i1027.EntityVersionRepositoryImpl>(
        () => _i1027.EntityVersionRepositoryImpl(gh<_i983.EntityVersionDao>()));
    gh.lazySingleton<_i392.EntityRepositoryImpl>(
        () => _i392.EntityRepositoryImpl(gh<_i573.EntityDao>()));
    gh.lazySingleton<_i319.TagRepositoryImpl>(
        () => _i319.TagRepositoryImpl(gh<_i932.TagDao>()));
    gh.lazySingleton<_i753.TimelineRepositoryImpl>(
        () => _i753.TimelineRepositoryImpl(gh<_i651.TimelineDao>()));
    gh.lazySingleton<_i625.MapRepositoryImpl>(
        () => _i625.MapRepositoryImpl(gh<_i1004.MapDao>()));
    gh.lazySingleton<_i456.ManuscriptRepositoryImpl>(
        () => _i456.ManuscriptRepositoryImpl(gh<_i25.ManuscriptDao>()));
    gh.lazySingleton<_i483.GetEntityReferencesUseCase>(
        () => _i483.GetEntityReferencesUseCase(
              gh<_i456.ManuscriptRepositoryImpl>(),
              gh<_i753.TimelineRepositoryImpl>(),
              gh<_i868.RelationshipRepositoryImpl>(),
            ));
    gh.lazySingleton<_i608.CreateChapterUseCase>(
        () => _i608.CreateChapterUseCase(gh<_i456.ManuscriptRepositoryImpl>()));
    gh.lazySingleton<_i608.UpdateChapterUseCase>(
        () => _i608.UpdateChapterUseCase(gh<_i456.ManuscriptRepositoryImpl>()));
    gh.lazySingleton<_i608.DeleteChapterUseCase>(
        () => _i608.DeleteChapterUseCase(gh<_i456.ManuscriptRepositoryImpl>()));
    gh.lazySingleton<_i608.ListChaptersUseCase>(
        () => _i608.ListChaptersUseCase(gh<_i456.ManuscriptRepositoryImpl>()));
    gh.lazySingleton<_i608.ReorderChaptersUseCase>(() =>
        _i608.ReorderChaptersUseCase(gh<_i456.ManuscriptRepositoryImpl>()));
    gh.lazySingleton<_i501.CreateEntityUseCase>(() => _i501.CreateEntityUseCase(
          gh<_i392.EntityRepositoryImpl>(),
          gh<_i1027.EntityVersionRepositoryImpl>(),
        ));
    gh.lazySingleton<_i178.UpdateEntityUseCase>(() => _i178.UpdateEntityUseCase(
          gh<_i392.EntityRepositoryImpl>(),
          gh<_i1027.EntityVersionRepositoryImpl>(),
        ));
    gh.lazySingleton<_i999.TemplateRepositoryImpl>(
        () => _i999.TemplateRepositoryImpl(gh<_i573.TemplateDao>()));
    gh.lazySingleton<_i522.ManuscriptCompiler>(() => _i522.ManuscriptCompiler(
          gh<_i456.ManuscriptRepositoryImpl>(),
          gh<_i392.EntityRepositoryImpl>(),
        ));
    gh.lazySingleton<_i998.DeleteEntityUseCase>(() => _i998.DeleteEntityUseCase(
          gh<_i392.EntityRepositoryImpl>(),
          gh<_i868.RelationshipRepositoryImpl>(),
        ));
    gh.lazySingleton<_i313.SyncRepositoryImpl>(() => _i313.SyncRepositoryImpl(
          gh<_i392.EntityRepositoryImpl>(),
          gh<_i868.RelationshipRepositoryImpl>(),
          gh<_i319.TagRepositoryImpl>(),
          gh<_i753.TimelineRepositoryImpl>(),
          gh<_i999.TemplateRepositoryImpl>(),
          gh<_i625.MapRepositoryImpl>(),
          gh<_i456.ManuscriptRepositoryImpl>(),
          gh<_i925.BackupSynchronizer>(),
        ));
    gh.lazySingleton<_i132.ListEntitiesUseCase>(
        () => _i132.ListEntitiesUseCase(gh<_i392.EntityRepositoryImpl>()));
    gh.lazySingleton<_i791.BootstrapUseCase>(
        () => _i791.BootstrapUseCase(gh<_i999.TemplateRepositoryImpl>()));
    gh.lazySingleton<_i1060.CreateTimelineEntryUseCase>(() =>
        _i1060.CreateTimelineEntryUseCase(gh<_i753.TimelineRepositoryImpl>()));
    gh.lazySingleton<_i780.ReorderTimelineUseCase>(
        () => _i780.ReorderTimelineUseCase(gh<_i753.TimelineRepositoryImpl>()));
    gh.lazySingleton<_i714.ExportDatabaseUseCase>(
        () => _i714.ExportDatabaseUseCase(
              gh<_i392.EntityRepositoryImpl>(),
              gh<_i868.RelationshipRepositoryImpl>(),
              gh<_i319.TagRepositoryImpl>(),
              gh<_i753.TimelineRepositoryImpl>(),
              gh<_i999.TemplateRepositoryImpl>(),
              gh<_i1027.EntityVersionRepositoryImpl>(),
              gh<_i625.MapRepositoryImpl>(),
            ));
    gh.lazySingleton<_i885.AssignTagUseCase>(
        () => _i885.AssignTagUseCase(gh<_i319.TagRepositoryImpl>()));
    gh.lazySingleton<_i417.CreateTagUseCase>(
        () => _i417.CreateTagUseCase(gh<_i319.TagRepositoryImpl>()));
    gh.lazySingleton<_i272.SampleWorldUseCase>(() => _i272.SampleWorldUseCase(
          gh<_i392.EntityRepositoryImpl>(),
          gh<_i1027.EntityVersionRepositoryImpl>(),
          gh<_i868.RelationshipRepositoryImpl>(),
          gh<_i753.TimelineRepositoryImpl>(),
          gh<_i456.ManuscriptRepositoryImpl>(),
          gh<_i625.MapRepositoryImpl>(),
          gh<_i89.PlotRepositoryImpl>(),
        ));
    gh.lazySingleton<_i564.ImportDatabaseUseCase>(
        () => _i564.ImportDatabaseUseCase(
              gh<_i392.EntityRepositoryImpl>(),
              gh<_i868.RelationshipRepositoryImpl>(),
              gh<_i319.TagRepositoryImpl>(),
              gh<_i753.TimelineRepositoryImpl>(),
              gh<_i999.TemplateRepositoryImpl>(),
              gh<_i625.MapRepositoryImpl>(),
            ));
    gh.lazySingleton<_i907.SyncBackupUseCase>(
        () => _i907.SyncBackupUseCase(gh<_i313.SyncRepositoryImpl>()));
    return this;
  }
}
