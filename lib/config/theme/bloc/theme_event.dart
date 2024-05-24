part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {}

class ChangeThemeEvent extends ThemeEvent {
  MaterialColor primarySwatchColor;
  ChangeThemeEvent(this.primarySwatchColor);

  @override
  List<Object?> get props => [primarySwatchColor];
}
