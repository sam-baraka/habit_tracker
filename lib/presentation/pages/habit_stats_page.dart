import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/domain/services/gamification_service.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:solutech_interview/presentation/widgets/animated_stat_card.dart';

@RoutePage()
class HabitStatsPage extends StatelessWidget {
  final Habit habit;

  const HabitStatsPage({
    super.key,
    required this.habit,
  });

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;
    final completionRate = 100.0;
    final weeklyData = _calculateWeeklyData();

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 1200),
          child: SingleChildScrollView(
            padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                _buildProgressSection(theme, context),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _buildStatsGrid(theme, completionRate, context),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _buildWeeklyChart(theme, weeklyData, context),
                SizedBox(height: isSmallScreen ? 16 : 24),
                _buildAchievementsSection(theme, context),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressSection(ThemeData theme, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
            const SizedBox(height: 16),
            TweenAnimationBuilder<double>(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 1000),
              curve: Curves.easeOut,
              builder: (context, value, child) {
                final xpProgress = habit.xp % GamificationService.xpPerLevel;
                final animatedProgress =
                    value * (xpProgress / GamificationService.xpPerLevel);
                return Column(
                  children: [
                    LinearProgressIndicator(
                      value: animatedProgress,
                      minHeight: isSmallScreen ? 8 : 12,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '${(animatedProgress * 100).toInt()}% to Level ${habit.level + 1}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                );
              },
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatsGrid(
      ThemeData theme, double completionRate, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: isSmallScreen ? 2 : 4,
      mainAxisSpacing: isSmallScreen ? 8 : 16,
      crossAxisSpacing: isSmallScreen ? 8 : 16,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard('Completion Rate',
            '${completionRate.toStringAsFixed(1)}%', theme, context),
        _buildStatCard(
            'Current Streak', '${habit.currentStreak} days', theme, context),
        _buildStatCard(
            'Best Streak', '${habit.currentStreak} days', theme, context),
        _buildStatCard(
            'Total Days', habit.currentStreak.toString(), theme, context),
      ],
    );
  }

  Widget _buildStatCard(
      String label, String value, ThemeData theme, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 8 : 16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              value,
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 18 : 24,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: theme.textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWeeklyChart(
      ThemeData theme, Map<String, int> weeklyData, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: isSmallScreen ? 200 : 300,
              child: ListView.separated(
                scrollDirection: Axis.horizontal,
                itemCount: weeklyData.length,
                separatorBuilder: (context, index) =>
                    SizedBox(width: isSmallScreen ? 8 : 16),
                itemBuilder: (context, index) {
                  final entry = weeklyData.entries.elementAt(index);
                  final percentage = entry.value / 7 * 100;
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        width: isSmallScreen ? 30 : 40,
                        height:
                            (isSmallScreen ? 150 : 250) * (percentage / 100),
                        decoration: BoxDecoration(
                          color: theme.colorScheme.primary,
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(entry.key, style: theme.textTheme.bodySmall),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(ThemeData theme, BuildContext context) {
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Card(
      child: Padding(
        padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleLarge?.copyWith(
                fontSize: isSmallScreen ? 20 : 24,
              ),
            ),
            const SizedBox(height: 16),
            if (habit.achievements.isEmpty)
              const Center(
                child: Text('No achievements yet. Keep going!'),
              )
            else
              ListView.separated(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: habit.achievements.length,
                separatorBuilder: (_, __) => const Divider(),
                itemBuilder: (context, index) {
                  final achievement = habit.achievements[index];
                  return ListTile(
                    leading: Image.asset(
                      achievement.iconPath,
                      width: isSmallScreen ? 40 : 48,
                      height: isSmallScreen ? 40 : 48,
                    ),
                    title: Text(achievement.name),
                    subtitle: Text(achievement.description),
                    trailing: Text(
                      _formatDate(achievement.unlockedAt),
                      style: theme.textTheme.bodySmall,
                    ),
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  Map<String, int> _calculateWeeklyData() {
    // Existing implementation
    return {
      'Mon': 5,
      'Tue': 3,
      'Wed': 7,
      'Thu': 4,
      'Fri': 6,
      'Sat': 2,
      'Sun': 5,
    };
  }
}
