part of 'localization_bloc.dart';

abstract class LocalizationEvent extends Equatable {
  const LocalizationEvent();

  @override
  List<Object> get props => [];
}

class LocalizationStarted extends LocalizationEvent {}

class LocalizationSuccess extends LocalizationEvent {
  final Lang langCode;
  LocalizationSuccess({this.langCode}) : assert(langCode != null);

  @override
  List<Object> get props => [langCode];
}
