import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';
import 'package:solutech_interview/domain/models/habit.dart';
import 'package:solutech_interview/presentation/blocs/habit/habit_bloc.dart';

@GenerateMocks([HabitRepository])
import 'habit_bloc_test.mocks.dart';

void main() {
  late MockHabitRepository mockHabitRepository;
  late HabitBloc habitBloc;

  setUp(() {
    mockHabitRepository = MockHabitRepository();
    habitBloc = HabitBloc(habitRepository: mockHabitRepository);
  });

  tearDown(() {
    habitBloc.close();
  });

  group('HabitBloc', () {
    final testHabit = Habit.create(
      name: 'Test Habit',
      description: 'Test Description',
      userId: 'test-user-id',
      frequency: 3,
    );

    test('initial state is correct', () {
      expect(habitBloc.state, equals(const HabitState()));
    });

    blocTest<HabitBloc, HabitState>(
      'LoadHabits emits [loading, success] when successful',
      build: () {
        when(mockHabitRepository.getUserHabits('test-user-id'))
            .thenAnswer((_) => Stream.value([testHabit]));
        return habitBloc;
      },
      act: (bloc) => bloc.add(const LoadHabits('test-user-id')),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        HabitState(
          status: HabitStatus.success,
          habits: [testHabit],
        ),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'AddHabit emits [loading, success] when successful',
      build: () {
        when(mockHabitRepository.createHabit(testHabit))
            .thenAnswer((_) => Future.value(testHabit));
        return habitBloc;
      },
      act: (bloc) => bloc.add(AddHabit(testHabit)),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        const HabitState(status: HabitStatus.success),
      ],
    );

    blocTest<HabitBloc, HabitState>(
      'MarkHabitCompleted emits [loading, success] with updated habit',
      build: () {
        final updatedHabit = testHabit.copyWith(
          completedDates: [DateTime.now()],
          currentStreak: 1,
          xp: 10,
        );
        when(mockHabitRepository.markHabitAsCompleted(testHabit))
            .thenAnswer((_) => Future.value(updatedHabit));
        return habitBloc;
      },
      act: (bloc) => bloc.add(MarkHabitCompleted(testHabit)),
      expect: () => [
        const HabitState(status: HabitStatus.loading),
        predicate<HabitState>(
          (state) =>
              state.status == HabitStatus.success &&
              state.lastCompletedHabit != null &&
              state.lastCompletedHabit!.currentStreak == 1,
        ),
      ],
    );


  });
} 