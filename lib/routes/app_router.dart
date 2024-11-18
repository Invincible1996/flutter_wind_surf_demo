import 'package:auto_route/auto_route.dart';
import 'package:flutter_wind_surf_demo/screens/login_screen.dart';
import 'package:flutter_wind_surf_demo/screens/home_screen.dart';
import 'package:flutter_wind_surf_demo/screens/splash_screen.dart';
import 'package:flutter_wind_surf_demo/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_wind_surf_demo/web_view_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: SplashRoute.page,
          initial: true,
          path: '/',
        ),
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: '/home',
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        ),
      ];
}
