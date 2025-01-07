import 'package:auto_route/auto_route.dart';
import 'package:solutech_interview/routes/router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  List<AutoRoute> get routes =>
      [AutoRoute(page: MainHomeRoute.page, initial: true, path: '/home')];
}
