// ignore_for_file: public_member_api_docs, sort_constructors_first
part of 'theme_bloc.dart';

abstract class ThemeState extends Equatable {}

class ThemeInitial extends ThemeState {
  ThemeData? theme;
  ThemeInitial({
    this.theme,
  });
  @override
  List<Object?> get props => [theme];
}

class ThemeComplete extends ThemeState {
  ThemeData? theme;
  ThemeComplete(
    this.theme,
  );

  @override
  List<Object?> get props => [theme];
}

class ThemeError extends ThemeState {
  String? message;
  @override
  List<Object?> get props => [message];
}
