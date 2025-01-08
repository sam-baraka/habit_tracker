import 'package:equatable/equatable.dart';

class Achievement extends Equatable {
  final String id;
  final String name;
  final String description;
  final String iconPath;
  final DateTime unlockedAt;

  const Achievement({
    required this.id,
    required this.name,
    required this.description,
    required this.iconPath,
    required this.unlockedAt,
  });

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'iconPath': iconPath,
        'unlockedAt': unlockedAt.toIso8601String(),
      };

  factory Achievement.fromJson(Map<String, dynamic> json) => Achievement(
        id: json['id'] as String,
        name: json['name'] as String,
        description: json['description'] as String,
        iconPath: json['iconPath'] as String,
        unlockedAt: DateTime.parse(json['unlockedAt'] as String),
      );

  @override
  List<Object?> get props => [id, name, description, iconPath, unlockedAt];
}
