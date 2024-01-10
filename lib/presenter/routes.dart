import 'package:go_router/go_router.dart';
import 'package:orm_forecast/presenter/main/main_screen.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => const MainScreen(),
    ),
  ],
);