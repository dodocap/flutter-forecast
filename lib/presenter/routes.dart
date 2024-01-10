import 'package:go_router/go_router.dart';
import 'package:orm_forecast/di/di_setup.dart';
import 'package:orm_forecast/presenter/main/main_screen.dart';
import 'package:orm_forecast/presenter/main/main_view_model.dart';
import 'package:provider/provider.dart';

final routes = GoRouter(
  initialLocation: '/',
  routes: [
    GoRoute(
      path: '/',
      builder: (_, __) => ChangeNotifierProvider(
        create: (_) => getIt<MainViewModel>(),
        child: const MainScreen(),
      ),
    ),
  ],
);
