import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/mockito.dart';
import 'package:solutech_interview/presentation/blocs/auth/auth_bloc.dart';
import 'package:solutech_interview/domain/models/user.dart';
import '../mocks/mock_auth_repository.mocks.dart';

void main() {
  late MockAuthRepository mockAuthRepository;
  late AuthBloc authBloc;

  setUp(() {
    mockAuthRepository = MockAuthRepository();
    authBloc = AuthBloc(authRepository: mockAuthRepository);
  });

  tearDown(() {
    authBloc.close();
  });

  test('initial state is unauthenticated', () {
    expect(authBloc.state, const AuthState.unauthenticated());
  });

  group('AuthSignUpRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [loading, signUpSuccess] when signup is successful',
      build: () {
        when(mockAuthRepository.signUp(
          email: 'test@example.com',
          password: 'password123',
        )).thenAnswer((_) async {});
        when(mockAuthRepository.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUpRequested('test@example.com', 'password123'),
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.signUpSuccess(),
      ],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when signup fails',
      build: () {
        when(mockAuthRepository.signUp(
          email: 'test@example.com',
          password: 'password123',
        )).thenThrow(Exception('Signup failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthSignUpRequested('test@example.com', 'password123'),
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('Exception: Signup failed'),
      ],
    );
  });

  group('AuthLoginRequested', () {


    blocTest<AuthBloc, AuthState>(
      'emits [loading, error] when login fails',
      build: () {
        when(mockAuthRepository.signIn(
          email: 'test@example.com',
          password: 'wrong-password',
        )).thenThrow(Exception('Invalid credentials'));
        return authBloc;
      },
      act: (bloc) => bloc.add(
        const AuthLoginRequested('test@example.com', 'wrong-password'),
      ),
      expect: () => [
        const AuthState.loading(),
        const AuthState.error('Exception: Invalid credentials'),
      ],
    );
  });

  group('AuthLogoutRequested', () {
    blocTest<AuthBloc, AuthState>(
      'emits [unauthenticated] when logout is successful',
      build: () {
        when(mockAuthRepository.signOut()).thenAnswer((_) async {});
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [const AuthState.unauthenticated()],
    );

    blocTest<AuthBloc, AuthState>(
      'emits [error] when logout fails',
      build: () {
        when(mockAuthRepository.signOut())
            .thenThrow(Exception('Logout failed'));
        return authBloc;
      },
      act: (bloc) => bloc.add(AuthLogoutRequested()),
      expect: () => [const AuthState.error('Exception: Logout failed')],
    );
  });

  group('AuthUserChanged', () {
    test('emits authenticated state when user is not null', () {
      final mockUser = User(
        id: 'test-id',
        email: 'test@example.com',
        displayName: 'Test User',
        lastSyncTime: DateTime.now(),
      );

      authBloc.add(AuthUserChanged(mockUser));

      expect(
        authBloc.stream,
        emits(AuthState.authenticated(mockUser)),
      );
    });

    test('emits unauthenticated state when user is null', () {
      authBloc.add(const AuthUserChanged(null));

      expect(
        authBloc.stream,
        emits(const AuthState.unauthenticated()),
      );
    });
  });
} 