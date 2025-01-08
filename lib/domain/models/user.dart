import 'package:equatable/equatable.dart';

class User extends Equatable {
  final String id;
  final String email;
  final String displayName;
  final int totalXp;
  final int level;
  final List<String> badges;
  final DateTime lastSyncTime;

  const User({
    required this.id,
    required this.email,
    required this.displayName,
    this.totalXp = 0,
    this.level = 1,
    this.badges = const [],
    required this.lastSyncTime,
  });

  User copyWith({
    String? displayName,
    int? totalXp,
    int? level,
    List<String>? badges,
    DateTime? lastSyncTime,
  }) {
    return User(
      id: id,
      email: email,
      displayName: displayName ?? this.displayName,
      totalXp: totalXp ?? this.totalXp,
      level: level ?? this.level,
      badges: badges ?? this.badges,
      lastSyncTime: lastSyncTime ?? this.lastSyncTime,
    );
  }

  @override
  List<Object?> get props => [
        id,
        email,
        displayName,
        totalXp,
        level,
        badges,
        lastSyncTime,
      ];
} 