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
import 'package:fictionist/data/dao/quick_capture_dao.dart' as _i1036;
import 'package:fictionist/data/dao/relationship_dao.dart' as _i499;
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
import 'package:fictionist/data/repository/quick_capture_repository_impl.dart'
    as _i887;
import 'package:fictionist/data/repository/relationship_repository_impl.dart'
    as _i868;
import 'package:fictionist/data/repository/sync_repository_impl.dart' as _i313;
import 'package:fictionist/data/repository/tag_repository_impl.dart' as _i319;
import 'package:fictionist/data/repository/template_repository_impl.dart'
    as _i999;
import 'package:fictionist/data/repository/timeline_repository_impl.dart'
    as _i753;
import 'package:fictionist/domain/repository/entity_repository.dart' as _i339;
import 'package:fictionist/domain/repository/entity_version_repository.dart'
    as _i36;
import 'package:fictionist/domain/repository/manuscript_repository.dart'
    as _i743;
import 'package:fictionist/domain/repository/map_repository.dart' as _i308;
import 'package:fictionist/domain/repository/name_generator_repository.dart'
    as _i553;
import 'package:fictionist/domain/repository/quick_capture_repository.dart'
    as _i1014;
import 'package:fictionist/domain/repository/relationship_repository.dart'
    as _i838;
import 'package:fictionist/domain/repository/sync_repository.dart' as _i226;
import 'package:fictionist/domain/repository/tag_repository.dart' as _i523;
import 'package:fictionist/domain/repository/template_repository.dart' as _i179;
import 'package:fictionist/domain/repository/timeline_repository.dart' as _i577;
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
import 'package:fictionist/domain/use_case/entity/get_entity_use_case.dart'
    as _i631;
import 'package:fictionist/domain/use_case/entity/list_entities_use_case.dart'
    as _i132;
import 'package:fictionist/domain/use_case/entity/search_entities_use_case.dart'
    as _i698;
import 'package:fictionist/domain/use_case/entity/search_entities_with_snippets_use_case.dart'
    as _i722;
import 'package:fictionist/domain/use_case/entity/update_entity_use_case.dart'
    as _i178;
import 'package:fictionist/domain/use_case/export/export_database_use_case.dart'
    as _i714;
import 'package:fictionist/domain/use_case/export/import_database_use_case.dart'
    as _i564;
import 'package:fictionist/domain/use_case/manuscript/manuscript_use_cases.dart'
    as _i608;
import 'package:fictionist/domain/use_case/map/create_world_map_use_case.dart'
    as _i900;
import 'package:fictionist/domain/use_case/map/delete_world_map_use_case.dart'
    as _i943;
import 'package:fictionist/domain/use_case/map/get_all_world_maps_use_case.dart'
    as _i270;
import 'package:fictionist/domain/use_case/map/get_pins_for_map_use_case.dart'
    as _i242;
import 'package:fictionist/domain/use_case/map/remove_map_pin_use_case.dart'
    as _i408;
import 'package:fictionist/domain/use_case/map/save_map_pin_use_case.dart'
    as _i701;
import 'package:fictionist/domain/use_case/name_generator/generate_names_use_case.dart'
    as _i802;
import 'package:fictionist/domain/use_case/quick_capture/create_quick_capture_use_case.dart'
    as _i402;
import 'package:fictionist/domain/use_case/quick_capture/process_quick_capture_use_case.dart'
    as _i701;
import 'package:fictionist/domain/use_case/relationship/create_relationship_use_case.dart'
    as _i664;
import 'package:fictionist/domain/use_case/relationship/delete_relationship_use_case.dart'
    as _i253;
import 'package:fictionist/domain/use_case/relationship/get_all_relationships_use_case.dart'
    as _i392;
import 'package:fictionist/domain/use_case/relationship/get_entity_relationships_use_case.dart'
    as _i452;
import 'package:fictionist/domain/use_case/sync/sync_backup_use_case.dart'
    as _i907;
import 'package:fictionist/domain/use_case/tag/assign_tag_use_case.dart'
    as _i885;
import 'package:fictionist/domain/use_case/tag/create_tag_use_case.dart'
    as _i417;
import 'package:fictionist/domain/use_case/tag/get_tags_use_case.dart' as _i883;
import 'package:fictionist/domain/use_case/template/get_templates_use_case.dart'
    as _i431;
import 'package:fictionist/domain/use_case/timeline/create_timeline_entry_use_case.dart'
    as _i1060;
import 'package:fictionist/domain/use_case/timeline/get_timeline_use_case.dart'
    as _i980;
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
    gh.lazySingleton<_i925.BackupSynchronizer>(
        () => _i925.BackupSynchronizer());
    gh.lazySingleton<_i356.ContinuityCheckUseCase>(
        () => _i356.ContinuityCheckUseCase());
    gh.lazySingleton<_i366.AnalyzeTraitInheritanceUseCase>(
        () => _i366.AnalyzeTraitInheritanceUseCase());
    gh.lazySingleton<_i397.WikilinkEngine>(() => _i397.WikilinkEngine());
    gh.lazySingleton<_i553.NameGeneratorRepository>(
        () => _i284.NameGeneratorRepositoryImpl());
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
    gh.lazySingleton<_i1036.QuickCaptureDao>(
        () => _i1036.QuickCaptureDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i499.RelationshipDao>(
        () => _i499.RelationshipDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i932.TagDao>(() => _i932.TagDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i573.TemplateDao>(
        () => _i573.TemplateDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i651.TimelineDao>(
        () => _i651.TimelineDao(gh<_i92.AppDatabase>()));
    gh.lazySingleton<_i577.TimelineRepository>(
        () => _i753.TimelineRepositoryImpl(gh<_i651.TimelineDao>()));
    gh.lazySingleton<_i339.EntityRepository>(
        () => _i392.EntityRepositoryImpl(gh<_i573.EntityDao>()));
    gh.lazySingleton<_i838.RelationshipRepository>(
        () => _i868.RelationshipRepositoryImpl(gh<_i499.RelationshipDao>()));
    gh.lazySingleton<_i89.PlotRepository>(
        () => _i89.PlotRepository(gh<_i476.PlotDao>()));
    gh.lazySingleton<_i36.EntityVersionRepository>(
        () => _i1027.EntityVersionRepositoryImpl(gh<_i983.EntityVersionDao>()));
    gh.lazySingleton<_i523.TagRepository>(
        () => _i319.TagRepositoryImpl(gh<_i932.TagDao>()));
    gh.lazySingleton<_i501.CreateEntityUseCase>(() => _i501.CreateEntityUseCase(
          gh<_i339.EntityRepository>(),
          gh<_i36.EntityVersionRepository>(),
        ));
    gh.lazySingleton<_i178.UpdateEntityUseCase>(() => _i178.UpdateEntityUseCase(
          gh<_i339.EntityRepository>(),
          gh<_i36.EntityVersionRepository>(),
        ));
    gh.lazySingleton<_i802.GenerateNamesUseCase>(
        () => _i802.GenerateNamesUseCase(gh<_i553.NameGeneratorRepository>()));
    gh.lazySingleton<_i179.TemplateRepository>(
        () => _i999.TemplateRepositoryImpl(gh<_i573.TemplateDao>()));
    gh.lazySingleton<_i743.ManuscriptRepository>(
        () => _i456.ManuscriptRepositoryImpl(gh<_i25.ManuscriptDao>()));
    gh.lazySingleton<_i522.ManuscriptCompiler>(() => _i522.ManuscriptCompiler(
          gh<_i743.ManuscriptRepository>(),
          gh<_i339.EntityRepository>(),
        ));
    gh.lazySingleton<_i1014.QuickCaptureRepository>(
        () => _i887.QuickCaptureRepositoryImpl(gh<_i1036.QuickCaptureDao>()));
    gh.lazySingleton<_i1060.CreateTimelineEntryUseCase>(() =>
        _i1060.CreateTimelineEntryUseCase(gh<_i577.TimelineRepository>()));
    gh.lazySingleton<_i980.GetTimelineUseCase>(
        () => _i980.GetTimelineUseCase(gh<_i577.TimelineRepository>()));
    gh.lazySingleton<_i780.ReorderTimelineUseCase>(
        () => _i780.ReorderTimelineUseCase(gh<_i577.TimelineRepository>()));
    gh.lazySingleton<_i608.CreateChapterUseCase>(
        () => _i608.CreateChapterUseCase(gh<_i743.ManuscriptRepository>()));
    gh.lazySingleton<_i608.UpdateChapterUseCase>(
        () => _i608.UpdateChapterUseCase(gh<_i743.ManuscriptRepository>()));
    gh.lazySingleton<_i608.DeleteChapterUseCase>(
        () => _i608.DeleteChapterUseCase(gh<_i743.ManuscriptRepository>()));
    gh.lazySingleton<_i608.ListChaptersUseCase>(
        () => _i608.ListChaptersUseCase(gh<_i743.ManuscriptRepository>()));
    gh.lazySingleton<_i608.ReorderChaptersUseCase>(
        () => _i608.ReorderChaptersUseCase(gh<_i743.ManuscriptRepository>()));
    gh.lazySingleton<_i308.MapRepository>(
        () => _i625.MapRepositoryImpl(gh<_i1004.MapDao>()));
    gh.lazySingleton<_i664.CreateRelationshipUseCase>(() =>
        _i664.CreateRelationshipUseCase(gh<_i838.RelationshipRepository>()));
    gh.lazySingleton<_i253.DeleteRelationshipUseCase>(() =>
        _i253.DeleteRelationshipUseCase(gh<_i838.RelationshipRepository>()));
    gh.lazySingleton<_i392.GetAllRelationshipsUseCase>(() =>
        _i392.GetAllRelationshipsUseCase(gh<_i838.RelationshipRepository>()));
    gh.lazySingleton<_i452.GetEntityRelationshipsUseCase>(() =>
        _i452.GetEntityRelationshipsUseCase(
            gh<_i838.RelationshipRepository>()));
    gh.lazySingleton<_i631.GetEntityUseCase>(
        () => _i631.GetEntityUseCase(gh<_i339.EntityRepository>()));
    gh.lazySingleton<_i132.ListEntitiesUseCase>(
        () => _i132.ListEntitiesUseCase(gh<_i339.EntityRepository>()));
    gh.lazySingleton<_i698.SearchEntitiesUseCase>(
        () => _i698.SearchEntitiesUseCase(gh<_i339.EntityRepository>()));
    gh.lazySingleton<_i722.SearchEntitiesWithSnippetsUseCase>(() =>
        _i722.SearchEntitiesWithSnippetsUseCase(gh<_i339.EntityRepository>()));
    gh.lazySingleton<_i885.AssignTagUseCase>(
        () => _i885.AssignTagUseCase(gh<_i523.TagRepository>()));
    gh.lazySingleton<_i417.CreateTagUseCase>(
        () => _i417.CreateTagUseCase(gh<_i523.TagRepository>()));
    gh.lazySingleton<_i883.GetTagsUseCase>(
        () => _i883.GetTagsUseCase(gh<_i523.TagRepository>()));
    gh.lazySingleton<_i701.ProcessQuickCaptureUseCase>(
        () => _i701.ProcessQuickCaptureUseCase(
              gh<_i1014.QuickCaptureRepository>(),
              gh<_i339.EntityRepository>(),
              gh<_i501.CreateEntityUseCase>(),
              gh<_i178.UpdateEntityUseCase>(),
            ));
    gh.lazySingleton<_i272.SampleWorldUseCase>(() => _i272.SampleWorldUseCase(
          gh<_i339.EntityRepository>(),
          gh<_i36.EntityVersionRepository>(),
          gh<_i838.RelationshipRepository>(),
          gh<_i577.TimelineRepository>(),
        ));
    gh.lazySingleton<_i564.ImportDatabaseUseCase>(
        () => _i564.ImportDatabaseUseCase(
              gh<_i339.EntityRepository>(),
              gh<_i838.RelationshipRepository>(),
              gh<_i523.TagRepository>(),
              gh<_i577.TimelineRepository>(),
              gh<_i179.TemplateRepository>(),
              gh<_i1014.QuickCaptureRepository>(),
              gh<_i308.MapRepository>(),
            ));
    gh.lazySingleton<_i226.SyncRepository>(() => _i313.SyncRepositoryImpl(
          gh<_i339.EntityRepository>(),
          gh<_i838.RelationshipRepository>(),
          gh<_i523.TagRepository>(),
          gh<_i577.TimelineRepository>(),
          gh<_i179.TemplateRepository>(),
          gh<_i1014.QuickCaptureRepository>(),
          gh<_i308.MapRepository>(),
          gh<_i743.ManuscriptRepository>(),
          gh<_i925.BackupSynchronizer>(),
        ));
    gh.lazySingleton<_i431.GetTemplatesUseCase>(
        () => _i431.GetTemplatesUseCase(gh<_i179.TemplateRepository>()));
    gh.lazySingleton<_i998.DeleteEntityUseCase>(() => _i998.DeleteEntityUseCase(
          gh<_i339.EntityRepository>(),
          gh<_i838.RelationshipRepository>(),
        ));
    gh.lazySingleton<_i907.SyncBackupUseCase>(
        () => _i907.SyncBackupUseCase(gh<_i226.SyncRepository>()));
    gh.lazySingleton<_i900.CreateWorldMapUseCase>(
        () => _i900.CreateWorldMapUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i943.DeleteWorldMapUseCase>(
        () => _i943.DeleteWorldMapUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i270.GetAllWorldMapsUseCase>(
        () => _i270.GetAllWorldMapsUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i242.GetPinsForMapUseCase>(
        () => _i242.GetPinsForMapUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i408.RemoveMapPinUseCase>(
        () => _i408.RemoveMapPinUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i701.SaveMapPinUseCase>(
        () => _i701.SaveMapPinUseCase(gh<_i308.MapRepository>()));
    gh.lazySingleton<_i714.ExportDatabaseUseCase>(
        () => _i714.ExportDatabaseUseCase(
              gh<_i339.EntityRepository>(),
              gh<_i838.RelationshipRepository>(),
              gh<_i523.TagRepository>(),
              gh<_i577.TimelineRepository>(),
              gh<_i179.TemplateRepository>(),
              gh<_i1014.QuickCaptureRepository>(),
              gh<_i36.EntityVersionRepository>(),
              gh<_i308.MapRepository>(),
            ));
    gh.lazySingleton<_i402.CreateQuickCaptureUseCase>(() =>
        _i402.CreateQuickCaptureUseCase(gh<_i1014.QuickCaptureRepository>()));
    gh.lazySingleton<_i791.BootstrapUseCase>(
        () => _i791.BootstrapUseCase(gh<_i179.TemplateRepository>()));
    return this;
  }
}
