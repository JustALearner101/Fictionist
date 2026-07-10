import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../common/widget/app_scaffold.dart';
import '../features/entity/screen/entity_create_screen.dart';
import '../features/entity/screen/entity_detail_screen.dart';
import '../features/entity/screen/entity_edit_screen.dart';
import '../features/entity/screen/entity_list_screen.dart';
import '../features/graph/screen/graph_screen.dart';
import '../features/inbox/screen/inbox_screen.dart';
import '../features/manuscript/screen/manuscript_screen.dart';
import '../features/map/screen/map_screen.dart';
import '../features/plot/screen/plot_canvas_screen.dart';
import '../features/settings/screen/settings_screen.dart';
import '../features/theme/screen/theme_screen.dart';
import '../features/timeline/screen/timeline_screen.dart';
import '../features/search/screen/search_screen.dart';

final GlobalKey<NavigatorState> _rootNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'root');
final GlobalKey<NavigatorState> _shellNavigatorKey =
    GlobalKey<NavigatorState>(debugLabel: 'shell');

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
          pageBuilder: (context, state) => const NoTransitionPage(
            child: EntityListScreen(),
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
          pageBuilder: (context, state) => const NoTransitionPage(
            child: TimelineScreen(),
          ),
        ),
        GoRoute(
          path: '/manuscript',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: ManuscriptScreen(),
          ),
        ),
        GoRoute(
          path: '/graph',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: GraphScreen(),
          ),
        ),
        GoRoute(
          path: '/plot',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: PlotCanvasScreen(),
          ),
        ),
        GoRoute(
          path: '/map',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: MapScreen(),
          ),
        ),
        GoRoute(
          path: '/inbox',
          pageBuilder: (context, state) => const NoTransitionPage(
            child: InboxScreen(),
          ),
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
