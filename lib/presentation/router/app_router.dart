import 'package:fictionist/presentation/common/widget/app_scaffold.dart';
import 'package:fictionist/presentation/features/entity/screen/entity_create_screen.dart';
import 'package:fictionist/presentation/features/entity/screen/entity_detail_screen.dart';
import 'package:fictionist/presentation/features/entity/screen/entity_edit_screen.dart';
import 'package:fictionist/presentation/features/entity/screen/entity_list_screen.dart';
import 'package:fictionist/presentation/features/graph/screen/graph_screen.dart';
import 'package:fictionist/presentation/features/manuscript/screen/chapter_editor_screen.dart';
import 'package:fictionist/presentation/features/manuscript/screen/manuscript_screen.dart';
import 'package:fictionist/presentation/features/map/screen/map_generator_screen.dart';
import 'package:fictionist/presentation/features/map/screen/map_screen.dart';
import 'package:fictionist/presentation/features/plot/screen/plot_canvas_screen.dart';
import 'package:fictionist/presentation/features/project/screen/project_selection_screen.dart';
import 'package:fictionist/presentation/features/search/screen/search_screen.dart';
import 'package:fictionist/presentation/features/settings/screen/settings_screen.dart';
import 'package:fictionist/presentation/features/theme/screen/theme_screen.dart';
import 'package:fictionist/presentation/features/timeline/screen/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../presentation/features/project/provider/active_project_provider.dart';
import '../../presentation/features/project/provider/project_guard.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

const _workspacePaths = ['/entities', '/timeline', '/manuscript', '/graph', '/plot', '/map'];

Page<dynamic> _fadeTransitionPage(
    BuildContext context, GoRouterState state, Widget child) {
  return CustomTransitionPage<void>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) {
      return FadeTransition(
        opacity: animation,
        child: child,
      );
    },
    transitionDuration: const Duration(milliseconds: 200),
  );
}

GoRouter buildAppRouter(WidgetRef ref) {
  final guard = ProjectGuard(ref);

  return GoRouter(
    navigatorKey: _rootNavigatorKey,
    initialLocation: '/',
    refreshListenable: guard,
    redirect: (context, state) {
      final project = ref.read(activeProjectProvider).valueOrNull;
      final location = state.uri.toString();

      // Root → projects
      if (location == '/') return '/projects';

      // On project selection screen: if project auto-loaded, go to workspace
      if (location == '/projects' && project != null) return '/entities';

      // On workspace routes: if no project, redirect to selection
      if (_workspacePaths.any((p) => location.startsWith(p))) {
        if (project == null) return '/projects';
      }

      return null;
    },
    routes: [
      GoRoute(
        path: '/',
        redirect: (_, __) => '/projects',
      ),
      GoRoute(
        path: '/projects',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (_, __) => const ProjectSelectionScreen(),
      ),
      ShellRoute(
        navigatorKey: _shellNavigatorKey,
        builder: (context, state, child) {
          return AppScaffold(child: child);
        },
        routes: [
          GoRoute(
            path: '/entities',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const EntityListScreen(),
            ),
            routes: [
              GoRoute(
                path: 'create',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const EntityCreateScreen(),
              ),
              GoRoute(
                path: ':id',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return EntityDetailScreen(entityId: id);
                },
              ),
              GoRoute(
                path: ':id/edit',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final id = state.pathParameters['id'] ?? '';
                  return EntityEditScreen(entityId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/timeline',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const TimelineScreen(),
            ),
          ),
          GoRoute(
            path: '/manuscript',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const ManuscriptScreen(),
            ),
            routes: [
              GoRoute(
                path: 'write/:chapterId',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) {
                  final id = state.pathParameters['chapterId'] ?? '';
                  return ChapterEditorScreen(chapterId: id);
                },
              ),
            ],
          ),
          GoRoute(
            path: '/graph',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const GraphScreen(),
            ),
          ),
          GoRoute(
            path: '/plot',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const PlotCanvasScreen(),
            ),
          ),
          GoRoute(
            path: '/map',
            pageBuilder: (context, state) => _fadeTransitionPage(
              context,
              state,
              const MapScreen(),
            ),
            routes: [
              GoRoute(
                path: 'generator',
                parentNavigatorKey: _rootNavigatorKey,
                builder: (context, state) => const MapGeneratorScreen(),
              ),
            ],
          ),
        ],
      ),
      GoRoute(
        path: '/settings',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SettingsScreen(),
      ),
      GoRoute(
        path: '/settings/theme',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const ThemeScreen(),
      ),
      GoRoute(
        path: '/search',
        parentNavigatorKey: _rootNavigatorKey,
        builder: (context, state) => const SearchScreen(),
      ),
    ],
  );
}
