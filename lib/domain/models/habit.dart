import 'package:equatable/equatable.dart';
import 'package:uuid/uuid.dart';

class Habit extends Equatable {
  final String id;
  final String name;
  final String description;
  final String userId;
  final int frequency; // days per week
  final DateTime startDate;
  final int currentStreak;
  final int longestStreak;
  final int level;
  final int xp;
  final List<DateTime> completedDates;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.frequency,
    required this.startDate,
    this.currentStreak = 0,
    this.longestStreak = 0,
    this.level = 1,
    this.xp = 0,
    this.completedDates = const [],
  });

  factory Habit.create({
    required String name,
    required String description,
    required String userId,
    required int frequency,
  }) {
    return Habit(
      id: const Uuid().v4(),
      name: name,
      description: description,
      userId: userId,
      frequency: frequency,
      startDate: DateTime.now(),
    );
  }

  Habit copyWith({
    String? name,
    String? description,
    int? frequency,
    int? currentStreak,
    int? longestStreak,
    int? level,
    int? xp,
    List<DateTime>? completedDates,
  }) {
    return Habit(
      id: id,
      name: name ?? this.name,
      description: description ?? this.description,
      userId: userId,
      frequency: frequency ?? this.frequency,
      startDate: startDate,
      currentStreak: currentStreak ?? this.currentStreak,
      longestStreak: longestStreak ?? this.longestStreak,
      level: level ?? this.level,
      xp: xp ?? this.xp,
      completedDates: completedDates ?? this.completedDates,
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        userId,
        frequency,
        startDate,
        currentStreak,
        longestStreak,
        level,
        xp,
        completedDates,
      ];
} 