import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/pages/achievements_page.dart';
import 'package:solutech_interview/presentation/pages/analytics_page.dart';
import 'package:solutech_interview/presentation/pages/habit_stats_page.dart';
import 'package:solutech_interview/presentation/pages/habits_page.dart';
import 'package:solutech_interview/presentation/pages/login_page.dart';
import 'package:solutech_interview/presentation/pages/main_home_page.dart';
import 'package:solutech_interview/presentation/pages/profile_page.dart';
import 'package:solutech_interview/presentation/pages/signup_page.dart';

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
        AutoRoute(
          page: HabitStatsRoute.page,
          path: '/habit_stats/:habitId',
        ),
        AutoRoute(
          page: AchievementsRoute.page,
          path: '/achievements',
        ),
        AutoRoute(
          page: AnalyticsRoute.page,
          path: '/analytics',
        ),
        AutoRoute(
          page: ProfileRoute.page,
          path: '/profile',
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
