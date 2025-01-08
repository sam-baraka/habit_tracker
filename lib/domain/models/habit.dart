import 'package:equatable/equatable.dart';
import 'package:solutech_interview/domain/models/achievement.dart';
import 'package:uuid/uuid.dart';

class Habit extends Equatable {
  final String id;
  final String name;
  final String description;
  final String userId;
  final int frequency;
  final DateTime startDate;
  final int currentStreak;
  final int longestStreak;
  final int level;
  final int xp;
  final List<DateTime> completedDates;
  final List<Achievement> achievements;

  const Habit({
    required this.id,
    required this.name,
    required this.description,
    required this.userId,
    required this.frequency,
    required this.startDate,
    required this.currentStreak,
    required this.longestStreak,
    required this.level,
    required this.xp,
    required this.completedDates,
    required this.achievements,
  });

  static Habit create({
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
      currentStreak: 0,
      longestStreak: 0,
      level: 1,
      xp: 0,
      completedDates: [],
      achievements: [],
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'userId': userId,
        'frequency': frequency,
        'startDate': startDate.toIso8601String(),
        'currentStreak': currentStreak,
        'longestStreak': longestStreak,
        'level': level,
        'xp': xp,
        'completedDates':
            completedDates.map((d) => d.toIso8601String()).toList(),
        'achievements': achievements.map((a) => a.toJson()).toList(),
      };

  factory Habit.fromJson(Map<String, dynamic> json) => Habit(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        userId: json['userId'] as String,
        frequency: json['frequency'] as int,
        startDate: DateTime.parse(json['startDate'] as String),
        currentStreak: json['currentStreak'] as int,
        longestStreak: json['longestStreak'] as int,
        level: json['level'] as int,
        xp: json['xp'] as int,
        completedDates: ((json['completedDates'] as List?) ?? [])
            .map((d) => DateTime.parse(d as String))
            .toList(),
        achievements: ((json['achievements'] as List?) ?? [])
            .map((a) => Achievement.fromJson(a as Map<String, dynamic>))
            .toList(),
      );

  Habit copyWith({
    String? name,
    String? description,
    int? frequency,
    int? currentStreak,
    int? longestStreak,
    int? level,
    int? xp,
    List<DateTime>? completedDates,
    List<Achievement>? achievements,
  }) =>
      Habit(
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
        achievements: achievements ?? this.achievements,
      );

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
        achievements,
      ];
}
