import 'package:go_router/go_router.dart';
import '../../features/control/presentation/control_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';
import '../../features/status/presentation/status_page.dart';
import '../widgets/app_shell.dart';
import '../widgets/placeholder_page.dart';
import '../../features/history/presentation/history_page.dart';
import '../../features/settings/presentation/settings_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    StatefulShellRoute.indexedStack(
      builder: (context, state, shell) => AppShell(navigationShell: shell),
      branches: [
        StatefulShellBranch(routes: [
          GoRoute(path: '/', builder: (_, __) => const DashboardPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(path: '/control', builder: (_, __) => const ControlPage()),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/status',
            builder: (_, __) => const StatusPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/history',
            builder: (_, __) => const HistoryPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/settings',
            builder: (_, __) => const SettingsPage(),
          ),
        ]),
        StatefulShellBranch(routes: [
          GoRoute(
            path: '/voice',
            builder: (_, __) => const PlaceholderPage(title: 'Assistente de Voz'),
          ),
        ])
      ],
    ),
  ],
);