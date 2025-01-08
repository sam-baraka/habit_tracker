import 'dart:async';
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';
import 'package:solutech_interview/domain/models/habit.dart';

part 'habit_event.dart';
part 'habit_state.dart';

class HabitBloc extends Bloc<HabitEvent, HabitState> {
  final HabitRepository _habitRepository;
  StreamSubscription<List<Habit>>? _habitsSubscription;

  HabitBloc({required HabitRepository habitRepository})
      : _habitRepository = habitRepository,
        super(const HabitState()) {
    on<LoadHabits>(_onLoadHabits);
    on<UpdateHabits>(_onUpdateHabits);
    on<AddHabit>(_onAddHabit);
    on<UpdateHabit>(_onUpdateHabit);
    on<DeleteHabit>(_onDeleteHabit);
    on<MarkHabitCompleted>(_onMarkHabitCompleted);
  }

  Future<void> _onLoadHabits(
    LoadHabits event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));

    await _habitsSubscription?.cancel();
    _habitsSubscription = _habitRepository.getUserHabits(event.userId).listen(
      (habits) {
        add(UpdateHabits(habits));
      },
    );
  }

  void _onUpdateHabits(
    UpdateHabits event,
    Emitter<HabitState> emit,
  ) {
    emit(state.copyWith(
      status: HabitStatus.success,
      habits: event.habits,
    ));
  }

  Future<void> _onAddHabit(
    AddHabit event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));

    try {
      await _habitRepository.createHabit(event.habit);
      emit(state.copyWith(status: HabitStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: HabitStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onUpdateHabit(
    UpdateHabit event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));

    try {
      await _habitRepository.updateHabit(event.habit);
      emit(state.copyWith(status: HabitStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: HabitStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onDeleteHabit(
    DeleteHabit event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));

    try {
      FirebaseAuth auth = FirebaseAuth.instance;
      await _habitRepository.deleteHabit(event.habitId, auth.currentUser!.uid);
      emit(state.copyWith(status: HabitStatus.success));
    } catch (e) {
      emit(state.copyWith(
        status: HabitStatus.failure,
        error: e.toString(),
      ));
    }
  }

  Future<void> _onMarkHabitCompleted(
    MarkHabitCompleted event,
    Emitter<HabitState> emit,
  ) async {
    emit(state.copyWith(status: HabitStatus.loading));

    try {
      final updatedHabit = await _habitRepository.markHabitAsCompleted(
        event.habit,
      );
      emit(state.copyWith(
        status: HabitStatus.success,
        lastCompletedHabit: updatedHabit,
      ));
    } catch (e) {
      emit(state.copyWith(
        status: HabitStatus.failure,
        error: e.toString(),
      ));
    }
  }

  @override
  Future<void> close() {
    _habitsSubscription?.cancel();
    return super.close();
  }
}
