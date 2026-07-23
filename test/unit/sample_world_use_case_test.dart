import 'package:fictionist/core/error/failure.dart';
import 'package:fictionist/domain/entity/entity.dart';
import 'package:fictionist/domain/entity/entity_type.dart';
import 'package:fictionist/domain/manuscript/manuscript_chapter.dart';
import 'package:fictionist/domain/map/map_pin.dart';
import 'package:fictionist/domain/map/world_map.dart';
import 'package:fictionist/domain/plot/plot_card.dart';
import 'package:fictionist/domain/relationship/relationship.dart';
import 'package:fictionist/data/repository/entity_repository_impl.dart';
import 'package:fictionist/data/repository/entity_version_repository_impl.dart';
import 'package:fictionist/data/repository/manuscript_repository_impl.dart';
import 'package:fictionist/data/repository/map_repository_impl.dart';
import 'package:fictionist/data/repository/plot_repository.dart';
import 'package:fictionist/data/repository/relationship_repository_impl.dart';
import 'package:fictionist/data/repository/timeline_repository_impl.dart';
import 'package:fictionist/domain/timeline/timeline_entry.dart';
import 'package:fictionist/domain/use_case/bootstrap/sample_world_use_case.dart';
import 'package:fictionist/domain/version/entity_version.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:fpdart/fpdart.dart';
import 'package:mocktail/mocktail.dart';

class MockEntityRepository extends Mock implements EntityRepositoryImpl {}

class MockEntityVersionRepository extends Mock
    implements EntityVersionRepositoryImpl {}

class MockRelationshipRepository extends Mock
    implements RelationshipRepositoryImpl {}

class MockTimelineRepository extends Mock implements TimelineRepositoryImpl {}

class MockManuscriptRepository extends Mock implements ManuscriptRepositoryImpl {}

class MockMapRepository extends Mock implements MapRepositoryImpl {}

class MockPlotRepository extends Mock implements PlotRepositoryImpl {}

void main() {
  late SampleWorldUseCase useCase;
  late MockEntityRepository mockEntityRepo;
  late MockEntityVersionRepository mockVersionRepo;
  late MockRelationshipRepository mockRelationshipRepo;
  late MockTimelineRepository mockTimelineRepo;
  late MockManuscriptRepository mockManuscriptRepo;
  late MockMapRepository mockMapRepo;
  late MockPlotRepository mockPlotRepo;

  setUpAll(() {
    registerFallbackValue(
      Entity(
        id: '',
        name: '',
        type: EntityType.character,
        iconColor: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      EntityVersion(
        id: '',
        entityId: '',
        snapshotJson: '',
        changedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      Relationship(
        id: '',
        sourceId: '',
        targetId: '',
        typeKey: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      TimelineEntry(
        id: '',
        title: '',
        sortOrder: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      ManuscriptChapter(
        id: '',
        title: '',
        content: '',
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      ),
    );
    registerFallbackValue(
      WorldMap(
        id: '',
        name: '',
        imagePath: '',
      ),
    );
    registerFallbackValue(
      MapPin(
        id: '',
        mapId: '',
        entityId: '',
        xPercent: 0,
        yPercent: 0,
      ),
    );
  });

  setUp(() {
    mockEntityRepo = MockEntityRepository();
    mockVersionRepo = MockEntityVersionRepository();
    mockRelationshipRepo = MockRelationshipRepository();
    mockTimelineRepo = MockTimelineRepository();
    mockManuscriptRepo = MockManuscriptRepository();
    mockMapRepo = MockMapRepository();
    mockPlotRepo = MockPlotRepository();
    useCase = SampleWorldUseCase(
      mockEntityRepo,
      mockVersionRepo,
      mockRelationshipRepo,
      mockTimelineRepo,
      mockManuscriptRepo,
      mockMapRepo,
      mockPlotRepo,
    );
  });

  test(
      'should successfully save sample entities, relationships, timeline entries, chapters, plots, maps and pins',
      () async {
    when(() => mockEntityRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as Entity)));
    when(() => mockVersionRepo.create(any())).thenAnswer((invocation) =>
        Future.value(
            Right(invocation.positionalArguments[0] as EntityVersion)));
    when(() => mockRelationshipRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as Relationship)));
    when(() => mockTimelineRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as TimelineEntry)));
    when(() => mockManuscriptRepo.create(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as ManuscriptChapter)));
    
    when(() => mockPlotRepo.createCard(
      title: any(named: 'title'),
      summary: any(named: 'summary'),
      xPosition: any(named: 'xPosition'),
      yPosition: any(named: 'yPosition'),
      colorHex: any(named: 'colorHex'),
    )).thenAnswer((invocation) {
      final title = invocation.namedArguments[#title] as String;
      final summary = invocation.namedArguments[#summary] as String?;
      final x = invocation.namedArguments[#xPosition] as double;
      final y = invocation.namedArguments[#yPosition] as double;
      final col = invocation.namedArguments[#colorHex] as int;
      return Future.value(Right(PlotCard(
        id: 'mock-card-id',
        title: title,
        summary: summary,
        xPosition: x,
        yPosition: y,
        colorHex: col,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
      )));
    });

    when(() => mockPlotRepo.createConnection(
      any(),
      any(),
      label: any(named: 'label'),
    )).thenAnswer((invocation) {
      final s = invocation.positionalArguments[0] as String;
      final t = invocation.positionalArguments[1] as String;
      final lbl = invocation.namedArguments[#label] as String?;
      return Future.value(Right(PlotConnection(
        id: 'mock-conn-id',
        sourceId: s,
        targetId: t,
        label: lbl,
        createdAt: DateTime.now(),
      )));
    });

    when(() => mockMapRepo.saveMapImage(any(), any())).thenAnswer((_) => Future.value(const Right(unit)));
    when(() => mockMapRepo.createMap(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as WorldMap)));
    when(() => mockMapRepo.createPin(any())).thenAnswer((invocation) =>
        Future.value(Right(invocation.positionalArguments[0] as MapPin)));

    final result = await useCase();

    expect(result.isRight(), true);
    result.fold(
      (failure) => fail('Should have succeeded but failed with $failure'),
      (val) => expect(val, unit),
    );

    verify(() => mockEntityRepo.create(any())).called(22);
    verify(() => mockVersionRepo.create(any())).called(22);
    verify(() => mockRelationshipRepo.create(any())).called(12);
    verify(() => mockTimelineRepo.create(any())).called(4);
    verify(() => mockManuscriptRepo.create(any())).called(3);
    verify(() => mockPlotRepo.createCard(
      title: any(named: 'title'),
      summary: any(named: 'summary'),
      xPosition: any(named: 'xPosition'),
      yPosition: any(named: 'yPosition'),
      colorHex: any(named: 'colorHex'),
    )).called(4);
    verify(() => mockPlotRepo.createConnection(
      any(),
      any(),
      label: any(named: 'label'),
    )).called(3);
    verify(() => mockMapRepo.saveMapImage(any(), any())).called(1);
    verify(() => mockMapRepo.createMap(any())).called(1);
    verify(() => mockMapRepo.createPin(any())).called(3);
  });

  test('should halt and return failure if entity insertion fails', () async {
    when(() => mockEntityRepo.create(any())).thenAnswer((_) => Future.value(
        const Left(Failure.database(message: 'Database error creating entity'))));

    final result = await useCase();

    expect(result.isLeft(), true);
    result.fold(
      (failure) {
        expect(failure, isA<DatabaseFailure>());
        expect(failure.message, 'Database error creating entity');
      },
      (_) => fail('Should have failed'),
    );

    verify(() => mockEntityRepo.create(any())).called(1);
    verifyNever(() => mockVersionRepo.create(any()));
    verifyNever(() => mockRelationshipRepo.create(any()));
    verifyNever(() => mockTimelineRepo.create(any()));
    verifyNever(() => mockManuscriptRepo.create(any()));
    verifyNever(() => mockPlotRepo.createCard(
      title: any(named: 'title'),
      summary: any(named: 'summary'),
      xPosition: any(named: 'xPosition'),
      yPosition: any(named: 'yPosition'),
      colorHex: any(named: 'colorHex'),
    ));
    verifyNever(() => mockMapRepo.saveMapImage(any(), any()));
  });
}
