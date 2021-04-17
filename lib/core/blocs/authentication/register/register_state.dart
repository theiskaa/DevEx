part of 'register_cubit.dart';

class RegisterState extends Equatable {
  final Username username;
  final Email email;
  final Password password;
  final ConfirmedPassword confirmedPassword;
  final FormzStatus formzStatus;
  final AuthStatus status;

  const RegisterState({
    this.username = const Username.pure(),
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.confirmedPassword = const ConfirmedPassword.pure(),
    this.formzStatus = FormzStatus.pure,
    this.status = AuthStatus.undefined,
  });

  @override
  List<Object> get props =>
      [username, email, password, confirmedPassword, formzStatus, status];

  RegisterState copyWith({
    Username username,
    Email email,
    Password password,
    ConfirmedPassword confirmedPassword,
    FormzStatus formzStatus,
    AuthStatus status,
  }) {
    return RegisterState(
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      confirmedPassword: confirmedPassword ?? this.confirmedPassword,
      formzStatus: formzStatus ?? this.formzStatus,
      status: status ?? this.status,
    );
  }
}
