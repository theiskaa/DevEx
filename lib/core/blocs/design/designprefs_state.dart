part of 'designprefs_bloc.dart';

class DesignprefsState extends Equatable {
  final bool isScrollSearchEnabled;
  final bool isFieldSearchEnabled;

  const DesignprefsState({
    this.isScrollSearchEnabled,
    this.isFieldSearchEnabled,
  });

  @override
  List<Object> get props => [isScrollSearchEnabled, isFieldSearchEnabled];
}
