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

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final completionRate = _calculateCompletionRate();
    final weeklyData = _getWeeklyCompletions();

    return Scaffold(
      appBar: AppBar(
        title: Text(habit.name),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildProgressSection(theme),
            const SizedBox(height: 24),
            _buildStatsGrid(theme, completionRate),
            const SizedBox(height: 24),
            _buildWeeklyChart(theme, weeklyData),
            const SizedBox(height: 24),
            _buildAchievementsSection(theme),
          ],
        ),
      ),
    );
  }

  Widget _buildProgressSection(ThemeData theme) {
    return TweenAnimationBuilder<double>(
      tween: Tween<double>(begin: 0, end: 1),
      duration: const Duration(milliseconds: 1000),
      curve: Curves.easeOut,
      builder: (context, value, child) {
        final xpForNext = GamificationService.xpForNextLevel(habit.xp);
        final xpProgress = habit.xp % GamificationService.xpPerLevel;
        final animatedProgress =
            value * (xpProgress / GamificationService.xpPerLevel);

        return Opacity(
          opacity: value,
          child: Card(
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'Level ${habit.level}',
                    style: theme.textTheme.headlineMedium,
                  ),
                  const SizedBox(height: 8),
                  LinearProgressIndicator(
                    value: animatedProgress,
                    backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    '$xpProgress / ${GamificationService.xpPerLevel} XP to next level',
                    style: theme.textTheme.bodyMedium,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGrid(ThemeData theme, double completionRate) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      children: [
        AnimatedStatCard(
          title: 'Current Streak',
          value: '${habit.currentStreak} days',
          icon: Icons.local_fire_department,
          color: Colors.orange,
          delay: const Duration(milliseconds: 0),
        ),
        AnimatedStatCard(
          title: 'Longest Streak',
          value: '${habit.longestStreak} days',
          icon: Icons.emoji_events,
          color: Colors.amber,
          delay: const Duration(milliseconds: 200),
        ),
        AnimatedStatCard(
          title: 'Completion Rate',
          value: '${(completionRate * 100).toStringAsFixed(1)}%',
          icon: Icons.insert_chart,
          color: Colors.blue,
          delay: const Duration(milliseconds: 400),
        ),
        AnimatedStatCard(
          title: 'Total XP',
          value: '${habit.xp} XP',
          icon: Icons.star,
          color: Colors.purple,
          delay: const Duration(milliseconds: 600),
        ),
      ],
    );
  }

  Widget _buildWeeklyChart(ThemeData theme, List<FlSpot> weeklyData) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Weekly Progress',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 200,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(show: false),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    topTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    rightTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        getTitlesWidget: (value, meta) {
                          const days = ['M', 'T', 'W', 'T', 'F', 'S', 'S'];
                          return Text(days[value.toInt()]);
                        },
                      ),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: weeklyData,
                      isCurved: true,
                      color: theme.colorScheme.primary,
                      barWidth: 4,
                      dotData: FlDotData(show: true),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAchievementsSection(ThemeData theme) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Achievements',
              style: theme.textTheme.titleLarge,
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
                  return TweenAnimationBuilder<double>(
                    tween: Tween<double>(begin: 0, end: 1),
                    duration: const Duration(milliseconds: 400),
                    curve: Curves.easeOut,
                    builder: (context, value, child) {
                      return Transform.translate(
                        offset: Offset(50 * (1 - value), 0),
                        child: Opacity(
                          opacity: value,
                          child: ListTile(
                            leading: Image.asset(
                              achievement.iconPath,
                              width: 40,
                              height: 40,
                            ),
                            title: Text(achievement.name),
                            subtitle: Text(achievement.description),
                            trailing: Text(
                              _formatDate(achievement.unlockedAt),
                              style: theme.textTheme.bodySmall,
                            ),
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
          ],
        ),
      ),
    );
  }

  double _calculateCompletionRate() {
    final daysFromStart = DateTime.now().difference(habit.startDate).inDays + 1;
    return habit.completedDates.length / daysFromStart;
  }

  List<FlSpot> _getWeeklyCompletions() {
    final now = DateTime.now();
    final weekStart = now.subtract(Duration(days: now.weekday - 1));
    final spots = <FlSpot>[];

    for (int i = 0; i < 7; i++) {
      final day = weekStart.add(Duration(days: i));
      final completed = habit.completedDates.any(
        (date) =>
            date.year == day.year &&
            date.month == day.month &&
            date.day == day.day,
      );
      spots.add(FlSpot(i.toDouble(), completed ? 1 : 0));
    }

    return spots;
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
