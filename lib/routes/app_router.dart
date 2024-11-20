import 'package:auto_route/auto_route.dart';
import 'package:flutter_wind_surf_demo/features/auth/presentation/pages/login_screen.dart';
import 'package:flutter_wind_surf_demo/features/auth/presentation/pages/splash_screen.dart';
import 'package:flutter_wind_surf_demo/features/settings/presentation/pages/settings_page.dart';
import 'package:flutter_wind_surf_demo/web_view_page.dart';
import 'package:flutter_wind_surf_demo/features/customer/presentation/pages/add_customer_screen.dart';
import 'package:flutter_wind_surf_demo/features/customer/presentation/pages/customer_list_screen.dart';
import '../features/auth/presentation/pages/home_screen.dart';

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
          page: CustomerListRoute.page,
          path: '/customers',
        ),
        AutoRoute(
          page: AddCustomerRoute.page,
          path: '/customers/add',
        ),
        AutoRoute(
          page: SettingsRoute.page,
          path: '/settings',
        ),
        AutoRoute(
          page: WebViewRoute.page,
          path: '/webview',
        ),
      ];
}
