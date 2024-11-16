import 'package:auto_route/auto_route.dart';
import 'package:web_video_demo/screens/home_screen.dart';
import 'package:web_video_demo/screens/login_screen.dart';
import 'package:web_video_demo/web_view_page.dart';

part 'app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          initial: true,
          path: '/login',
        ),
        AutoRoute(
          page: HomeRoute.page,
          path: '/home',
        ),
        AutoRoute(
          page: WebViewRoute.page,
          path: '/webview',
        ),
      ];
}
