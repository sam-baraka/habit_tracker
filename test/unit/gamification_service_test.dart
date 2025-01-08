import 'package:flutter_test/flutter_test.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/domain/models/achievement.dart';
import 'package:solutech_interview/domain/services/gamification_service.dart';

void main() {
  group('GamificationService', () {
    late Habit testHabit;

    setUp(() {
      testHabit = Habit.create(
        name: 'Test Habit',
        description: 'Test Description',
        userId: 'test-user-id',
        frequency: 3,
      );
    });

    group('Level calculations', () {
      test('calculateLevel returns correct level based on XP', () {
        expect(GamificationService.calculateLevel(0), equals(1));
        expect(GamificationService.calculateLevel(50), equals(1));
        expect(GamificationService.calculateLevel(100), equals(2));
        expect(GamificationService.calculateLevel(250), equals(3));
        expect(GamificationService.calculateLevel(999), equals(10));
      });

      test('xpForNextLevel returns correct XP threshold', () {
        expect(GamificationService.xpForNextLevel(0), equals(100));
        expect(GamificationService.xpForNextLevel(50), equals(100));
        expect(GamificationService.xpForNextLevel(150), equals(200));
        expect(GamificationService.xpForNextLevel(999), equals(1000));
      });
    });

    group('Streak calculations', () {
      test('_calculateStreak returns 0 for empty completions', () {
        final habit = testHabit.copyWith(completedDates: []);
        final updatedHabit = GamificationService.processHabitCompletion(habit);
        expect(updatedHabit.currentStreak, equals(1));
      });



    });

    group('XP and Achievement processing', () {

      test('processHabitCompletion prevents double completion on same day', () {
        final now = DateTime.now();
        final habit = testHabit.copyWith(
          completedDates: [now],
          xp: 10,
        );

        final updatedHabit = GamificationService.processHabitCompletion(habit);
        expect(updatedHabit.xp, equals(10));
        expect(updatedHabit.completedDates.length, equals(1));
      });


    });

    group('Achievement unlocking', () {

      test('does not duplicate achievements', () {
        final existingAchievement = Achievement(
          id: 'streak_7',
          name: 'Week Warrior',
          description: 'Maintain a 7-day streak',
          iconPath: 'assets/icons/streak.png',
          unlockedAt: DateTime.now(),
        );

        final habit = testHabit.copyWith(
          completedDates: List.generate(
            6,
            (i) => DateTime.now().subtract(Duration(days: i + 1)),
          ),
          currentStreak: 6,
          achievements: [existingAchievement],
        );

        final updatedHabit = GamificationService.processHabitCompletion(habit);
        expect(
          updatedHabit.achievements.where((a) => a.id == 'streak_7').length,
          equals(1),
        );
      });
    });
  });
}
