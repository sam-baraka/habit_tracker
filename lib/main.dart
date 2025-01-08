import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solutech_interview/core/theme/app_theme.dart';
import 'package:solutech_interview/firebase_options.dart';
import 'package:solutech_interview/routes/router.dart';
import 'package:solutech_interview/data/repositories/auth_repository.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';

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

  runApp(HabitTracker(
    authRepository: authRepository,
    habitRepository: habitRepository,
  ));
}

class HabitTracker extends StatelessWidget {
  final AuthRepository authRepository;
  final HabitRepository habitRepository;

  const HabitTracker({
    super.key,
    required this.authRepository,
    required this.habitRepository,
  });

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();

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
      ],
      child: MaterialApp.router(
        title: 'Habit Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
