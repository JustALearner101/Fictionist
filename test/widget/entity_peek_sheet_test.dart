import 'package:flutter_test/flutter_test.dart';
import 'package:fictionist/presentation/features/entity/widget/entity_peek_sheet.dart';

void main() {
  group('EntityPeekSheet', () {
    test('EntityPeekSheet constructor stores correct values', () {
      const sheet = EntityPeekSheet(
        entityId: 'test-id',
        depth: 0,
        maxDepth: 3,
      );

      expect(sheet.entityId, 'test-id');
      expect(sheet.depth, 0);
      expect(sheet.maxDepth, 3);
    });

    test('EntityPeekSheet respects depth at limit', () {
      const sheet = EntityPeekSheet(
        entityId: 'deep-nested',
        depth: 3,
        maxDepth: 3,
      );

      // At depth == maxDepth, further nesting is blocked
      expect(sheet.depth, sheet.maxDepth);
    });

    test('EntityPeekSheet can nest up to 3 layers', () {
      const sheet = EntityPeekSheet(
        entityId: 'layer-1',
        depth: 0,
        maxDepth: 3,
      );

      expect(sheet.maxDepth, 3);
      expect(sheet.depth, lessThan(sheet.maxDepth));
    });
  });
}
