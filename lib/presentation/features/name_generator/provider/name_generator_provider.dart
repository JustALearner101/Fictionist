import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:riverpod_annotation/riverpod_annotation.dart';

import 'package:fictionist/domain/name_generator/generated_name.dart';
import 'package:fictionist/domain/name_generator/generation_type.dart';
import 'package:fictionist/domain/name_generator/name_generator_params.dart';
import 'package:fictionist/domain/use_case/name_generator/generate_names_use_case.dart';
import 'package:fictionist/injection.dart';

part 'name_generator_provider.g.dart';

/// State for the name generator bottom sheet.
class NameGeneratorState {
  final GenerationType generationType;
  final String selectedArchetype;
  final List<GeneratedName> names;
  final bool isLoading;
  final String? errorMessage;

  const NameGeneratorState({
    this.generationType = GenerationType.characterName,
    this.selectedArchetype = 'Elven',
    this.names = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  NameGeneratorState copyWith({
    GenerationType? generationType,
    String? selectedArchetype,
    List<GeneratedName>? names,
    bool? isLoading,
    String? errorMessage,
  }) {
    return NameGeneratorState(
      generationType: generationType ?? this.generationType,
      selectedArchetype: selectedArchetype ?? this.selectedArchetype,
      names: names ?? this.names,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage,
    );
  }
}

@riverpod
class NameGeneratorNotifier extends _$NameGeneratorNotifier {
  @override
  NameGeneratorState build() {
    return const NameGeneratorState();
  }

  void setGenerationType(GenerationType type) {
    final useCase = getIt<GenerateNamesUseCase>();
    final archetypes = useCase.getArchetypesForType(type);
    state = state.copyWith(
      generationType: type,
      selectedArchetype:
          archetypes.isNotEmpty ? archetypes.first : 'Standard',
      names: const [],
      errorMessage: null,
    );
  }

  void setArchetype(String archetype) {
    state = state.copyWith(selectedArchetype: archetype);
  }

  Future<void> generate() async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    final useCase = getIt<GenerateNamesUseCase>();
    final result = await useCase(NameGeneratorParams(
      type: state.generationType,
      archetype: state.selectedArchetype,
      count: 5,
    ));

    result.fold(
      (failure) {
        state = state.copyWith(
          isLoading: false,
          errorMessage: failure.message,
        );
      },
      (names) {
        state = state.copyWith(
          isLoading: false,
          names: names,
        );
      },
    );
  }
}
