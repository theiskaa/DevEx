part of 'designprefs_bloc.dart';

abstract class DesignprefsEvent extends Equatable {
  const DesignprefsEvent();

  @override
  List<Object> get props => [];
}

// Switch events.
class EnableScrollSearch extends DesignprefsEvent {}

class EnableFieldSearch extends DesignprefsEvent {}

class DisbleScrollSearch extends DesignprefsEvent {}

class DisbleFieldSearch extends DesignprefsEvent {}

// Decide event.
class DecideDesignPrefs extends DesignprefsEvent {}
