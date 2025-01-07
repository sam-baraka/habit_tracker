import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:solutech_interview/routes/router.dart';

void main() {

  runApp(HabitTracker());
}

class HabitTracker extends StatelessWidget {
  HabitTracker({super.key});
  final _appRouter = AppRouter();
  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      routerConfig: _appRouter.config(),
    );
  }
}
