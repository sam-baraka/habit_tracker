import 'package:flutter/material.dart';
import 'package:auto_route/auto_route.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';
import 'package:solutech_interview/domain/models/achievement.dart';

@RoutePage()
class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isSmallScreen = MediaQuery.of(context).size.width < 600;

    return Scaffold(
      appBar: AppBar(
        title: const Text('Achievements'),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isSmallScreen ? double.infinity : 1200,
          ),
          child: BlocBuilder<HabitBloc, HabitState>(
            builder: (context, state) {
              final allAchievements = _getAllAchievements(state);

              if (allAchievements.isEmpty) {
                return Center(
                  child: Padding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 32),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.emoji_events_outlined,
                          size: isSmallScreen ? 64 : 96,
                          color: theme.colorScheme.primary.withOpacity(0.5),
                        ),
                        SizedBox(height: isSmallScreen ? 16 : 24),
                        Text(
                          'No achievements yet',
                          style: theme.textTheme.titleLarge?.copyWith(
                            fontSize: isSmallScreen ? 24 : 32,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          'Keep building your habits to earn achievements!',
                          style: theme.textTheme.bodyMedium,
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                );
              }

              return CustomScrollView(
                slivers: [
                  SliverPadding(
                    padding: EdgeInsets.all(isSmallScreen ? 16 : 24),
                    sliver: SliverToBoxAdapter(
                      child: _buildAchievementStats(
                        context,
                        allAchievements,
                        isSmallScreen,
                      ),
                    ),
                  ),
                  SliverPadding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    sliver: SliverList(
                      delegate: SliverChildBuilderDelegate(
                        (context, index) {
                          final achievement = allAchievements[index];
                          return _AchievementCard(
                            achievement: achievement,
                            habitName: _getHabitName(state, achievement),
                          );
                        },
                        childCount: allAchievements.length,
                      ),
                    ),
                  ),
                ],
              );
            },
          ),
        ),
      ),
    );
  }

  Widget _buildAchievementStats(
    BuildContext context,
    List<Achievement> achievements,
    bool isSmallScreen,
  ) {
    final theme = Theme.of(context);
    final totalAchievements = achievements.length;
    final streakAchievements =
        achievements.where((a) => a.id.startsWith('streak_')).length;
    final levelAchievements =
        achievements.where((a) => a.id.startsWith('level_')).length;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              'Achievement Progress',
              style: theme.textTheme.titleLarge,
            ),
            const SizedBox(height: 16),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildStatColumn(
                  context,
                  'Total',
                  totalAchievements.toString(),
                  Icons.emoji_events,
                ),
                _buildStatColumn(
                  context,
                  'Streaks',
                  streakAchievements.toString(),
                  Icons.local_fire_department,
                ),
                _buildStatColumn(
                  context,
                  'Levels',
                  levelAchievements.toString(),
                  Icons.military_tech,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatColumn(
    BuildContext context,
    String label,
    String value,
    IconData icon,
  ) {
    final theme = Theme.of(context);

    return Column(
      children: [
        Icon(icon, color: theme.colorScheme.primary),
        const SizedBox(height: 8),
        Text(
          value,
          style: theme.textTheme.headlineSmall,
        ),
        Text(
          label,
          style: theme.textTheme.bodySmall,
        ),
      ],
    );
  }

  List<Achievement> _getAllAchievements(HabitState state) {
    final achievements = <Achievement>[];
    for (final habit in state.habits) {
      achievements.addAll(habit.achievements);
    }
    achievements.sort((a, b) => b.unlockedAt.compareTo(a.unlockedAt));
    return achievements;
  }

  String _getHabitName(HabitState state, Achievement achievement) {
    final habit = state.habits.firstWhere(
      (h) => h.achievements.any((a) => a.id == achievement.id),
      orElse: () => throw Exception('Habit not found for achievement'),
    );
    return habit.name;
  }
}

class _AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final String habitName;

  const _AchievementCard({
    required this.achievement,
    required this.habitName,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      margin: const EdgeInsets.only(bottom: 16),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Image.asset(
              achievement.iconPath,
              width: 48,
              height: 48,
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    achievement.name,
                    style: theme.textTheme.titleMedium,
                  ),
                  Text(
                    achievement.description,
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'Earned in: $habitName',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: theme.colorScheme.primary,
                    ),
                  ),
                  Text(
                    'Unlocked: ${_formatDate(achievement.unlockedAt)}',
                    style: theme.textTheme.bodySmall,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
