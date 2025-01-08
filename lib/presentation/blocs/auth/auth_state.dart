part of 'auth_bloc.dart';

class AuthState extends Equatable {
  final User? user;
  final bool isLoading;
  final String? error;
  final bool isSignUpSuccess;

  const AuthState._({
    this.user,
    this.isLoading = false,
    this.error,
    this.isSignUpSuccess = false,
  });

  const AuthState.authenticated(User user) : this._(user: user);

  const AuthState.unauthenticated() : this._();

  const AuthState.loading() : this._(isLoading: true);

  const AuthState.error(String error) : this._(error: error);

  const AuthState.signUpSuccess() : this._(isSignUpSuccess: true);

  @override
  List<Object?> get props => [user, isLoading, error, isSignUpSuccess];
} 