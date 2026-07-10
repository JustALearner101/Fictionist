import 'package:freezed_annotation/freezed_annotation.dart';
import '../entity/entity.dart';

part 'search_result.freezed.dart';

@freezed
abstract class SearchResult with _$SearchResult {
  const factory SearchResult({
    required Entity entity,
    required String snippet,
  }) = _SearchResult;
}
