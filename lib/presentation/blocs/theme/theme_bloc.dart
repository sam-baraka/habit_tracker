import 'package:hydrated_bloc/hydrated_bloc.dart';
import 'package:equatable/equatable.dart';

// Events
abstract class ThemeEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class ThemeChanged extends ThemeEvent {
  final bool isDarkMode;
  ThemeChanged(this.isDarkMode);

  @override
  List<Object?> get props => [isDarkMode];
}

// State
class ThemeState extends Equatable {
  final bool isDarkMode;

  const ThemeState({required this.isDarkMode});

  @override
  List<Object?> get props => [isDarkMode];
}

class ThemeBloc extends HydratedBloc<ThemeEvent, ThemeState> {
  ThemeBloc() : super(const ThemeState(isDarkMode: false)) {
    on<ThemeChanged>((event, emit) {
      emit(ThemeState(isDarkMode: event.isDarkMode));
    });
  }

  @override
  ThemeState? fromJson(Map<String, dynamic> json) {
    return ThemeState(isDarkMode: json['isDarkMode'] as bool);
  }

  @override
  Map<String, dynamic>? toJson(ThemeState state) {
    return {'isDarkMode': state.isDarkMode};
  }
}
