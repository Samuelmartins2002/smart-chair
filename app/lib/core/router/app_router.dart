import 'package:go_router/go_router.dart';
import '../../features/control/presentation/control_page.dart';
import '../../features/dashboard/presentation/dashboard_page.dart';

final appRouter = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(path: '/', builder: (_, __) => const DashboardPage()),
    GoRoute(path: '/control', builder: (_, __) => const ControlPage()),
  ],
);