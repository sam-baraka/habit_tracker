import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HabitRepository {
  final FirebaseFirestore _firestore;
  final Box<Map> _habitBox;
  static const String _habitBoxName = 'habits';

  HabitRepository({
    FirebaseFirestore? firestore,
    Box<Map>? habitBox,
  })  : _firestore = firestore ?? FirebaseFirestore.instance,
        _habitBox = habitBox ?? Hive.box<Map>(_habitBoxName);

  static Future<void> init() async {
    if (!Hive.isBoxOpen('habits')) {
      await Hive.openBox<Map>('habits');
    }
  }

  // Create a new habit with user ID
  Future<Habit> createHabit(Habit habit) async {
    try {
      // Save to Firestore under user's collection
      await _firestore
          .collection('users')
          .doc(habit.userId)
          .collection('habits')
          .doc(habit.id)
          .set(habit.toJson());

      // Save to local storage with user ID as part of the key
      await _habitBox.put('${habit.userId}_${habit.id}', habit.toJson());

      return habit;
    } catch (e) {
      throw Exception('Failed to create habit: $e');
    }
  }

  // Get all habits for a specific user
  Stream<List<Habit>> getUserHabits(String userId) {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('habits')
        .snapshots()
        .map((snapshot) => snapshot.docs
            .map((doc) => Habit.fromJson(doc.data()))
            .toList());
  }

  // Update a habit
  Future<void> updateHabit(Habit habit) async {
    try {
      await _firestore
          .collection('users')
          .doc(habit.userId)
          .collection('habits')
          .doc(habit.id)
          .update(habit.toJson());

      await _habitBox.put('${habit.userId}_${habit.id}', habit.toJson());
    } catch (e) {
      throw Exception('Failed to update habit: $e');
    }
  }

  // Delete a habit
  Future<void> deleteHabit(String habitId, String userId) async {
    try {
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('habits')
          .doc(habitId)
          .delete();

      await _habitBox.delete('${userId}_${habitId}');
    } catch (e) {
      throw Exception('Failed to delete habit: $e');
    }
  }

  // Mark habit as completed
  Future<Habit> markHabitAsCompleted(Habit habit) async {
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    // Check if already completed today
    if (habit.completedDates.any((date) =>
        date.year == todayDate.year &&
        date.month == todayDate.month &&
        date.day == todayDate.day)) {
      return habit;
    }

    final updatedCompletedDates = [...habit.completedDates, todayDate];
    final updatedStreak = _calculateStreak(updatedCompletedDates);
    final updatedXp = habit.xp + 10;
    final updatedLevel = (updatedXp / 100).floor() + 1;

    final updatedHabit = habit.copyWith(
      completedDates: updatedCompletedDates,
      currentStreak: updatedStreak,
      longestStreak: updatedStreak > habit.longestStreak
          ? updatedStreak
          : habit.longestStreak,
      xp: updatedXp,
      level: updatedLevel,
    );

    await updateHabit(updatedHabit);
    return updatedHabit;
  }

  // Calculate current streak
  int _calculateStreak(List<DateTime> completedDates) {
    if (completedDates.isEmpty) return 0;

    completedDates.sort((a, b) => b.compareTo(a));
    final today = DateTime.now();
    final todayDate = DateTime(today.year, today.month, today.day);

    final lastCompletedDate = DateTime(
      completedDates.first.year,
      completedDates.first.month,
      completedDates.first.day,
    );

    if (lastCompletedDate.isBefore(todayDate.subtract(const Duration(days: 1)))) {
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

  // Get offline habits for a specific user
  List<Habit> getOfflineHabits(String userId) {
    try {
      return _habitBox.values
          .map((habitMap) => Habit.fromJson(Map<String, dynamic>.from(habitMap)))
          .where((habit) => habit.userId == userId)
          .toList();
    } catch (e) {
      return [];
    }
  }

  // Sync offline changes for a specific user
  Future<void> syncOfflineChanges(String userId) async {
    final offlineHabits = getOfflineHabits(userId);
    for (final habit in offlineHabits) {
      try {
        await _firestore
            .collection('users')
            .doc(userId)
            .collection('habits')
            .doc(habit.id)
            .set(habit.toJson());
      } catch (e) {
        print('Failed to sync habit ${habit.id}: $e');
      }
    }
  }
} 