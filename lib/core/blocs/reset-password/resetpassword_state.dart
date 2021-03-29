part of 'resetpassword_cubit.dart';

// ignore: must_be_immutable
class ResetpasswordState extends Equatable {
  final Email email;
  AuthStatus status;
  final FormzStatus formzStatus;

  ResetpasswordState({
    this.email = const Email.pure(),
    this.status = AuthStatus.undefined,
    this.formzStatus = FormzStatus.pure,
  })  : assert(email != null),
        assert(status != null),
        assert(formzStatus != null);

  ResetpasswordState copyWith({
    Email email,
    AuthStatus status,
    FormzStatus formzStatus,
  }) {
    return ResetpasswordState(
      email: email ?? this.email,
      status: status ?? this.status,
      formzStatus: formzStatus ?? this.formzStatus,
    );
  }

  @override
  List<Object> get props => [email, status, formzStatus];
}
