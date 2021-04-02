part of 'theme_bloc.dart';

abstract class ThemeEvent extends Equatable {
  const ThemeEvent();

  @override
  List<Object> get props => [];
}


class DecideTheme extends ThemeEvent {}

class LightTheme extends ThemeEvent {
  @override
  String toString() => 'Light Theme';
}

class DarkTheme extends ThemeEvent {
  @override
  String toString() => 'Dark Theme';
}