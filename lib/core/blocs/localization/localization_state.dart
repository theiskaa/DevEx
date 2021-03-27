part of 'localization_bloc.dart';

class LocalizationState extends Equatable {
  final Locale locale;
  const LocalizationState(this.locale) : assert(locale != null);

  @override
  List<Object> get props => [locale];
}
