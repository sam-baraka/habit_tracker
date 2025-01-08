import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocBuilder<HabitBloc, HabitState>(
      builder: (context, state) {
        final totalHabits = state.habits.length;
        final completedToday = state.habits.where((habit) {
          final today = DateTime.now();
          return habit.completedDates.any((date) =>
              date.year == today.year &&
              date.month == today.month &&
              date.day == today.day);
        }).length;

        final totalStreaks = state.habits.fold<int>(
          0,
          (sum, habit) => sum + habit.currentStreak,
        );

        return Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(16),
          ),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Total Habits',
                    totalHabits.toString(),
                    Icons.list_alt,
                  ),
                  _buildStatItem(
                    context,
                    'Completed Today',
                    '$completedToday/$totalHabits',
                    Icons.check_circle,
                  ),
                  _buildStatItem(
                    context,
                    'Total Streaks',
                    totalStreaks.toString(),
                    Icons.local_fire_department,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildStatItem(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    return Column(
      children: [
        Icon(
          icon,
          color: Colors.white,
          size: 24,
        ),
        const SizedBox(height: 8),
        Text(
          value,
          style: const TextStyle(
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            color: Colors.white70,
            fontSize: 12,
          ),
        ),
      ],
    );
  }
}
