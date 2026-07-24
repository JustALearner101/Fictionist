import 'package:flutter/foundation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'active_project_provider.dart';

/// Sync bridge between async Riverpod [activeProjectProvider] and
/// GoRouter's sync [refreshListenable].
class ProjectGuard extends ChangeNotifier {
  ProjectGuard(WidgetRef ref) {
    ref.listen(activeProjectProvider, (_, next) {
      next.whenData((_) => notifyListeners());
    });
  }
}
