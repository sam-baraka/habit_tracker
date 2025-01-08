import 'package:flutter/material.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/domain/services/gamification_service.dart';

class HabitProgressCard extends StatelessWidget {
  final Habit habit;

  const HabitProgressCard({
    super.key,
    required this.habit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final xpForNext = GamificationService.xpForNextLevel(habit.xp);
    final xpProgress = habit.xp % GamificationService.xpPerLevel;
    final progressPercent = xpProgress / GamificationService.xpPerLevel;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Level ${habit.level}',
                  style: theme.textTheme.titleLarge,
                ),
                Text(
                  '${habit.xp} XP',
                  style: theme.textTheme.titleMedium,
                ),
              ],
            ),
            const SizedBox(height: 8),
            LinearProgressIndicator(
              value: progressPercent,
              backgroundColor: theme.colorScheme.primary.withOpacity(0.2),
            ),
            const SizedBox(height: 4),
            Text(
              '${xpProgress} / ${GamificationService.xpPerLevel} XP to Level ${habit.level + 1}',
              style: theme.textTheme.bodySmall,
            ),
            if (habit.achievements.isNotEmpty) ...[
              const SizedBox(height: 16),
              Text(
                'Achievements',
                style: theme.textTheme.titleMedium,
              ),
              const SizedBox(height: 8),
              SizedBox(
                height: 80,
                child: ListView.separated(
                  scrollDirection: Axis.horizontal,
                  itemCount: habit.achievements.length,
                  separatorBuilder: (context, index) =>
                      const SizedBox(width: 8),
                  itemBuilder: (context, index) {
                    final achievement = habit.achievements[index];
                    return Tooltip(
                      message:
                          '${achievement.name}\n${achievement.description}',
                      child: Image.asset(
                        achievement.iconPath,
                        width: 48,
                        height: 48,
                      ),
                    );
                  },
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}
