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
import 'package:fictionist/presentation/features/search/screen/search_screen.dart';
import 'package:fictionist/presentation/features/settings/screen/settings_screen.dart';
import 'package:fictionist/presentation/features/theme/screen/theme_screen.dart';
import 'package:fictionist/presentation/features/timeline/screen/timeline_screen.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

Page<dynamic> _fadeTransitionPage(BuildContext context, GoRouterState state, Widget child) {
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

final GoRouter appRouter = GoRouter(
  navigatorKey: _rootNavigatorKey,
  initialLocation: '/entities',
  routes: [
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
