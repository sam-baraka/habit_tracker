import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solutech_interview/core/theme/app_theme.dart';
import 'package:solutech_interview/firebase_options.dart';
import 'package:solutech_interview/presentation/widgets/theme_selection_dialog.dart';
import 'package:solutech_interview/routes/router.dart';
import 'package:solutech_interview/data/repositories/auth_repository.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';
import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:path_provider/path_provider.dart';
import 'package:solutech_interview/presentation/blocs/theme/theme_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Initialize Hive
  await Hive.initFlutter();

  // Open Hive boxes
  await Hive.openBox<Map>('habits');
  await Hive.openBox<Map>('user_data');

  // Initialize repositories
  final authRepository = AuthRepository();
  final habitRepository = HabitRepository();

  // Initialize repositories
  await HabitRepository.init();

  // Initialize HydratedBloc storage
  HydratedBloc.storage = await HydratedStorage.build(
    storageDirectory: kIsWeb
        ? HydratedStorage.webStorageDirectory
        : await getApplicationDocumentsDirectory(),
  );

  // Initialize SharedPreferences for theme selection
  final prefs = await SharedPreferences.getInstance();
  final hasSelectedTheme = prefs.getBool('has_selected_theme') ?? false;

  runApp(HabitTracker(
    authRepository: authRepository,
    habitRepository: habitRepository,
    showThemeSelector: !hasSelectedTheme,
  ));
}

class HabitTracker extends StatelessWidget {
  final AuthRepository authRepository;
  final HabitRepository habitRepository;
  final bool showThemeSelector;

  HabitTracker({
    super.key,
    required this.authRepository,
    required this.habitRepository,
    this.showThemeSelector = false,
  });

  final _appRouter = AppRouter();

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(
          create: (context) => AuthBloc(
            authRepository: authRepository,
          ),
        ),
        BlocProvider(
          create: (context) => HabitBloc(
            habitRepository: habitRepository,
          ),
        ),
        BlocProvider(
          create: (context) => ThemeBloc(),
        ),
      ],
      child: BlocBuilder<ThemeBloc, ThemeState>(
        builder: (context, themeState) {
          return MaterialApp.router(
            title: 'Habit Tracker',
            theme: AppTheme.lightTheme,
            darkTheme: AppTheme.darkTheme,
            themeMode: themeState.isDarkMode ? ThemeMode.dark : ThemeMode.light,
            routerConfig: _appRouter.config(),
            builder: (context, child) {
              if (showThemeSelector) {
                WidgetsBinding.instance.addPostFrameCallback((_) {
                  showDialog(
                    context: context,
                    barrierDismissible: false,
                    builder: (context) => const ThemeSelectionDialog(),
                  ).then((_) async {
                    final prefs = await SharedPreferences.getInstance();
                    await prefs.setBool('has_selected_theme', true);
                  });
                });
              }
              return child ?? const SizedBox.shrink();
            },
          );
        },
      ),
    );
  }
}
