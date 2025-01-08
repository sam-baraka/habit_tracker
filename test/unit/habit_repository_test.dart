import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:solutech_interview/data/repositories/habit_repository.dart';
import 'package:solutech_interview/domain/models/habit.dart';

@GenerateMocks([
  FirebaseFirestore,
  Box,
], customMocks: [
  MockSpec<CollectionReference<Map<String, dynamic>>>(
    as: #MockCollectionReference,
  ),
  MockSpec<DocumentReference<Map<String, dynamic>>>(
    as: #MockDocumentReference,
  ),
  MockSpec<DocumentSnapshot<Map<String, dynamic>>>(
    as: #MockDocumentSnapshot,
  ),
  MockSpec<QuerySnapshot<Map<String, dynamic>>>(
    as: #MockQuerySnapshot,
  ),
  MockSpec<QueryDocumentSnapshot<Map<String, dynamic>>>(
    as: #MockQueryDocumentSnapshot,
  ),
])
import 'habit_repository_test.mocks.dart';

void main() {
  late MockFirebaseFirestore mockFirestore;
  late MockBox<Map> mockHabitBox;
  late HabitRepository habitRepository;
  late MockCollectionReference mockCollectionReference;
  late MockDocumentReference mockDocumentReference;

  setUp(() {
    mockFirestore = MockFirebaseFirestore();
    mockHabitBox = MockBox<Map>();
    mockCollectionReference = MockCollectionReference();
    mockDocumentReference = MockDocumentReference();
    habitRepository = HabitRepository(
      firestore: mockFirestore,
      habitBox: mockHabitBox,
    );
  });

  group('HabitRepository', () {
    final testHabit = Habit.create(
      name: 'Test Habit',
      description: 'Test Description',
      userId: 'test-user-id',
      frequency: 3,
    );

    test('createHabit saves to Firestore and local storage', () async {
      // Arrange
      when(mockFirestore.collection('users'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('test-user-id'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('habits'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(testHabit.id))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.set(any)).thenAnswer((_) => Future.value());
      when(mockHabitBox.put(any, any)).thenAnswer((_) => Future.value());

      // Act
      final result = await habitRepository.createHabit(testHabit);

      // Assert
      expect(result, equals(testHabit));
      verify(mockDocumentReference.set(testHabit.toJson())).called(1);
      verify(mockHabitBox.put('test-user-id_${testHabit.id}', testHabit.toJson()))
          .called(1);
    });

    test('getUserHabits returns stream of habits', () {
      // Arrange
      final mockQuerySnapshot = MockQuerySnapshot();
      final mockDocumentSnapshot = MockQueryDocumentSnapshot();
      
      when(mockDocumentSnapshot.id).thenReturn(testHabit.id);
      when(mockDocumentSnapshot.data()).thenReturn(testHabit.toJson());
      
      when(mockFirestore.collection('users'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('test-user-id'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('habits'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.snapshots())
          .thenAnswer((_) => Stream.value(mockQuerySnapshot));
      when(mockQuerySnapshot.docs).thenReturn([mockDocumentSnapshot]);

      // Act
      final habitStream = habitRepository.getUserHabits('test-user-id');

      // Assert
      expect(
        habitStream,
        emits(predicate<List<Habit>>(
          (habits) =>
              habits.length == 1 &&
              habits.first.id == testHabit.id &&
              habits.first.name == testHabit.name,
        )),
      );
    });


    test('deleteHabit removes from Firestore and local storage', () async {
      // Arrange
      when(mockFirestore.collection('users'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc('test-user-id'))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.collection('habits'))
          .thenReturn(mockCollectionReference);
      when(mockCollectionReference.doc(testHabit.id))
          .thenReturn(mockDocumentReference);
      when(mockDocumentReference.delete()).thenAnswer((_) => Future.value());
      when(mockHabitBox.delete(any)).thenAnswer((_) => Future.value());

      // Act
      await habitRepository.deleteHabit(testHabit.id, 'test-user-id');

      // Assert
      verify(mockDocumentReference.delete()).called(1);
      verify(mockHabitBox.delete('test-user-id_${testHabit.id}')).called(1);
    });
  });
}