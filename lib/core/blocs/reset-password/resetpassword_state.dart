part of 'resetpassword_cubit.dart';

// ignore: must_be_immutable
class ResetpasswordState extends Equatable {
  final Email email;
  final Password newPassword;
  AuthStatus status;
  final FormzStatus formzStatus;

  ResetpasswordState({
    this.email = const Email.pure(),
    this.newPassword = const Password.pure(),
    this.status = AuthStatus.undefined,
    this.formzStatus = FormzStatus.pure,
  })  : assert(email != null),
        assert(newPassword != null),
        assert(status != null),
        assert(formzStatus != null);

  ResetpasswordState copyWith({
    Email email,
    Password newPassword,
    AuthStatus status,
    FormzStatus formzStatus,
  }) {
    return ResetpasswordState(
      email: email ?? this.email,
      newPassword: newPassword ?? this.newPassword,
      status: status ?? this.status,
      formzStatus: formzStatus ?? this.formzStatus,
    );
  }

  @override
  List<Object> get props => [email, newPassword, status, formzStatus];
}
