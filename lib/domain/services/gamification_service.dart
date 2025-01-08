import 'package:uuid/uuid.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/domain/models/achievement.dart';

class GamificationService {
  static const int xpPerCompletion = 10;
  static const int xpPerStreak = 5;
  static const int xpPerLevel = 100;

  // Calculate level based on XP
  static int calculateLevel(int xp) {
    return (xp / xpPerLevel).floor() + 1;
  }

  // Calculate XP needed for next level
  static int xpForNextLevel(int currentXp) {
    final currentLevel = calculateLevel(currentXp);
    return currentLevel * xpPerLevel;
  }

  // Update habit stats after completion
  static Habit processHabitCompletion(Habit habit) {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if already completed today
    if (habit.completedDates.any((date) =>
        date.year == todayDate.year &&
        date.month == todayDate.month &&
        date.day == todayDate.day)) {
      return habit;
    }

    // Calculate new streak
    final updatedCompletedDates = [...habit.completedDates, todayDate];
    final currentStreak = _calculateStreak(updatedCompletedDates);

    // Calculate XP gain
    int xpGain = xpPerCompletion;
    if (currentStreak > habit.currentStreak) {
      xpGain += xpPerStreak;
    }

    final newXp = habit.xp + xpGain;
    final newLevel = calculateLevel(newXp);

    // Check for new achievements
    final newAchievements = [
      ...habit.achievements,
      ..._checkForNewAchievements(
        habit,
        currentStreak,
        newLevel,
        updatedCompletedDates.length,
      ),
    ];

    return habit.copyWith(
      completedDates: updatedCompletedDates,
      currentStreak: currentStreak,
      longestStreak: currentStreak > habit.longestStreak
          ? currentStreak
          : habit.longestStreak,
      xp: newXp,
      level: newLevel,
      achievements: newAchievements,
    );
  }

  static int _calculateStreak(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;

    completedDates.sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    if (completedDates.first
        .isBefore(todayDate.subtract(const Duration(days: 1)))) {
      return 0;
    }

    int streak = 1;
    for (int i = 0; i < completedDates.length - 1; i++) {
      final current = completedDates[i];
      final next = completedDates[i + 1];
      if (current.difference(next).inDays == 1) {
        streak++;
      } else {
        break;
      }
    }
    return streak;
  }

  static List<Achievement> _checkForNewAchievements(
    Habit habit,
    int currentStreak,
    int newLevel,
    int totalCompletions,
  ) {
    final newAchievements = <Achievement>[];
    final existingIds = habit.achievements.map((a) => a.id).toSet();

    // Streak achievements
    if (currentStreak >= 7 && !existingIds.contains('streak_7')) {
      newAchievements.add(_createAchievement(
        'streak_7',
        'Week Warrior',
        'Maintain a 7-day streak',
        'assets/icons/streak.png',
      ));
    }

    if (currentStreak >= 30 && !existingIds.contains('streak_30')) {
      newAchievements.add(_createAchievement(
        'streak_30',
        'Monthly Master',
        'Maintain a 30-day streak',
        'assets/icons/streak_gold.png',
      ));
    }

    // Level achievements
    if (newLevel >= 5 && !existingIds.contains('level_5')) {
      newAchievements.add(_createAchievement(
        'level_5',
        'Rising Star',
        'Reach level 5',
        'assets/icons/star.png',
      ));
    }

    if (newLevel >= 10 && !existingIds.contains('level_10')) {
      newAchievements.add(_createAchievement(
        'level_10',
        'Habit Master',
        'Reach level 10',
        'assets/icons/star_gold.png',
      ));
    }

    // Completion achievements
    if (totalCompletions >= 50 && !existingIds.contains('completions_50')) {
      newAchievements.add(_createAchievement(
        'completions_50',
        'Dedicated',
        'Complete habit 50 times',
        'assets/icons/trophy.png',
      ));
    }

    return newAchievements;
  }

  static Achievement _createAchievement(
    String id,
    String name,
    String description,
    String iconPath,
  ) {
    return Achievement(
      id: id,
      name: name,
      description: description,
      iconPath: iconPath,
      unlockedAt: DateTime.now(),
    );
  }
}
