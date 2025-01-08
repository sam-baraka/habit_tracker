import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/pages/habits_page.dart';
import 'package:solutech_interview/presentation/pages/login_page.dart';
import 'package:solutech_interview/presentation/pages/signup_page.dart';
import 'package:solutech_interview/widgets/main_home_page.dart';

part 'router.gr.dart';

@AutoRouterConfig()
class AppRouter extends _$AppRouter {
  @override
  List<AutoRoute> get routes => [
        AutoRoute(
          page: LoginRoute.page,
          path: '/login',
        ),
        AutoRoute(
          page: HabitsRoute.page,
          path: '/habits',
        ),
        AutoRoute(
          page: SignUpRoute.page,
          path: '/signup',
        ),
        AutoRoute(
          page: MainHomeRoute.page,
          path: '/home',
          guards: [AuthGuard()],
          initial: true,
        ),
      ];
}

class AuthGuard extends AutoRouteGuard {
  @override
  void onNavigation(NavigationResolver resolver, StackRouter router) {
    final authBloc = router.navigatorKey.currentContext?.read<AuthBloc>();

    if (authBloc?.state.user != null) {
      resolver.next(true);
    } else {
      router.push(const LoginRoute());
    }
  }
}
