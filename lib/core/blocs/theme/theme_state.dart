part of 'theme_bloc.dart';

class ThemeState extends Equatable {
  final ThemeData themeData;

  const ThemeState({
    @required this.themeData,
  }) : assert(themeData != null);

  @override
  List<Object> get props => [themeData];
}
