import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';

class StatsOverview extends StatelessWidget {
  const StatsOverview({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final screenWidth = MediaQuery.of(context).size.width;

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
          margin: EdgeInsets.symmetric(
            horizontal: isSmallScreen ? 16 : screenWidth * 0.1,
          ),
          padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [
                theme.colorScheme.primary,
                theme.colorScheme.secondary,
              ],
            ),
            borderRadius: BorderRadius.circular(isSmallScreen ? 16 : 24),
            boxShadow: [
              BoxShadow(
                color: theme.shadowColor.withOpacity(0.1),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: LayoutBuilder(
            builder: (context, constraints) {
              // Use Wrap for very small screens
              if (constraints.maxWidth < 400) {
                return Wrap(
                  spacing: 16,
                  runSpacing: 16,
                  alignment: WrapAlignment.spaceAround,
                  children: [
                    _buildStatItem(
                      context,
                      'Total Habits',
                      totalHabits.toString(),
                      Icons.list_alt,
                      isSmallScreen,
                    ),
                    _buildStatItem(
                      context,
                      'Completed Today',
                      '$completedToday/$totalHabits',
                      Icons.check_circle,
                      isSmallScreen,
                    ),
                    _buildStatItem(
                      context,
                      'Total Streaks',
                      totalStreaks.toString(),
                      Icons.local_fire_department,
                      isSmallScreen,
                    ),
                  ],
                );
              }

              // Use Row for larger screens
              return Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  _buildStatItem(
                    context,
                    'Total Habits',
                    totalHabits.toString(),
                    Icons.list_alt,
                    isSmallScreen,
                  ),
                  _buildStatItem(
                    context,
                    'Completed Today',
                    '$completedToday/$totalHabits',
                    Icons.check_circle,
                    isSmallScreen,
                  ),
                  _buildStatItem(
                    context,
                    'Total Streaks',
                    totalStreaks.toString(),
                    Icons.local_fire_department,
                    isSmallScreen,
                  ),
                ],
              );
            },
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
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: EdgeInsets.all(isSmallScreen ? 8 : 12),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            color: Colors.white,
            size: isSmallScreen ? 24 : 32,
          ),
          SizedBox(height: isSmallScreen ? 8 : 12),
          Text(
            value,
            style: TextStyle(
              color: Colors.white,
              fontSize: isSmallScreen ? 20 : 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          SizedBox(height: isSmallScreen ? 4 : 8),
          Text(
            label,
            style: TextStyle(
              color: Colors.white70,
              fontSize: isSmallScreen ? 12 : 14,
            ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}
