part of 'habit_bloc.dart';

abstract class HabitEvent extends Equatable {
  const HabitEvent();

  @override
  List<Object?> get props => [];
}

class LoadHabits extends HabitEvent {
  final String userId;

  const LoadHabits(this.userId);

  @override
  List<Object> get props => [userId];
}

class UpdateHabits extends HabitEvent {
  final List<Habit> habits;

  const UpdateHabits(this.habits);

  @override
  List<Object> get props => [habits];
}

class AddHabit extends HabitEvent {
  final Habit habit;

  const AddHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class UpdateHabit extends HabitEvent {
  final Habit habit;

  const UpdateHabit(this.habit);

  @override
  List<Object> get props => [habit];
}

class DeleteHabit extends HabitEvent {
  final String habitId;

  const DeleteHabit(this.habitId);

  @override
  List<Object> get props => [habitId];
}

class MarkHabitCompleted extends HabitEvent {
  final Habit habit;

  const MarkHabitCompleted(this.habit);

  @override
  List<Object> get props => [habit];
} 