part of 'habit_bloc.dart';

enum HabitStatus { initial, loading, success, failure }

class HabitState extends Equatable {
  final HabitStatus status;
  final List<Habit> habits;
  final String? error;
  final Habit? lastCompletedHabit;

  const HabitState({
    this.status = HabitStatus.initial,
    this.habits = const [],
    this.error,
    this.lastCompletedHabit,
  });

  HabitState copyWith({
    HabitStatus? status,
    List<Habit>? habits,
    String? error,
    Habit? lastCompletedHabit,
  }) {
    return HabitState(
      status: status ?? this.status,
      habits: habits ?? this.habits,
      error: error ?? this.error,
      lastCompletedHabit: lastCompletedHabit ?? this.lastCompletedHabit,
    );
  }

  @override
  List<Object?> get props => [status, habits, error, lastCompletedHabit];
} 