// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// AutoRouterGenerator
// **************************************************************************

// ignore_for_file: type=lint
// coverage:ignore-file

part of 'router.dart';

abstract class _$AppRouter extends RootStackRouter {
  // ignore: unused_element
  _$AppRouter({super.navigatorKey});

  @override
  final Map<String, PageFactory> pagesMap = {
    HabitStatsRoute.name: (routeData) {
      final args = routeData.argsAs<HabitStatsRouteArgs>();
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: HabitStatsPage(
          key: args.key,
          habit: args.habit,
        ),
      );
    },
    HabitsRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const HabitsPage(),
      );
    },
    LoginRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const LoginPage(),
      );
    },
    MainHomeRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const MainHomePage(),
      );
    },
    SignUpRoute.name: (routeData) {
      return AutoRoutePage<dynamic>(
        routeData: routeData,
        child: const SignUpPage(),
      );
    },
  };
}

/// generated route for
/// [HabitStatsPage]
class HabitStatsRoute extends PageRouteInfo<HabitStatsRouteArgs> {
  HabitStatsRoute({
    Key? key,
    required Habit habit,
    List<PageRouteInfo>? children,
  }) : super(
          HabitStatsRoute.name,
          args: HabitStatsRouteArgs(
            key: key,
            habit: habit,
          ),
          initialChildren: children,
        );

  static const String name = 'HabitStatsRoute';

  static const PageInfo<HabitStatsRouteArgs> page =
      PageInfo<HabitStatsRouteArgs>(name);
}

class HabitStatsRouteArgs {
  const HabitStatsRouteArgs({
    this.key,
    required this.habit,
  });

  final Key? key;

  final Habit habit;

  @override
  String toString() {
    return 'HabitStatsRouteArgs{key: $key, habit: $habit}';
  }
}

/// generated route for
/// [HabitsPage]
class HabitsRoute extends PageRouteInfo<void> {
  const HabitsRoute({List<PageRouteInfo>? children})
      : super(
          HabitsRoute.name,
          initialChildren: children,
        );

  static const String name = 'HabitsRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [LoginPage]
class LoginRoute extends PageRouteInfo<void> {
  const LoginRoute({List<PageRouteInfo>? children})
      : super(
          LoginRoute.name,
          initialChildren: children,
        );

  static const String name = 'LoginRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [MainHomePage]
class MainHomeRoute extends PageRouteInfo<void> {
  const MainHomeRoute({List<PageRouteInfo>? children})
      : super(
          MainHomeRoute.name,
          initialChildren: children,
        );

  static const String name = 'MainHomeRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}

/// generated route for
/// [SignUpPage]
class SignUpRoute extends PageRouteInfo<void> {
  const SignUpRoute({List<PageRouteInfo>? children})
      : super(
          SignUpRoute.name,
          initialChildren: children,
        );

  static const String name = 'SignUpRoute';

  static const PageInfo<void> page = PageInfo<void>(name);
}
