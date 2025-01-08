import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:solutech_interview/core/theme/app_theme.dart';
import 'package:solutech_interview/firebase_options.dart';
import 'package:solutech_interview/routes/router.dart';
import 'package:solutech_interview/data/repositories/auth_repository.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  // Initialize Firebase
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  
  // Initialize Hive
  await Hive.initFlutter();
  
  final authRepository = AuthRepository();
  
  runApp(HabitTracker(authRepository: authRepository));
}

class HabitTracker extends StatelessWidget {
  final AuthRepository authRepository;
  
  const HabitTracker({
    super.key,
    required this.authRepository,
  });

  @override
  Widget build(BuildContext context) {
    final _appRouter = AppRouter();
    
    return BlocProvider(
      create: (context) => AuthBloc(
        authRepository: authRepository,
      ),
      child: MaterialApp.router(
        title: 'Habit Tracker',
        theme: AppTheme.lightTheme,
        darkTheme: AppTheme.darkTheme,
        routerConfig: _appRouter.config(),
      ),
    );
  }
}
