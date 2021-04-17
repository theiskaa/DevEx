part of 'login_cubit.dart';

class LoginState extends Equatable {
  final Email email;
  final Password password;
  final AuthStatus status;
  final FormzStatus formzStatus;

  const LoginState({
    this.email = const Email.pure(),
    this.password = const Password.pure(),
    this.status = AuthStatus.undefined,
    this.formzStatus = FormzStatus.pure,
  });

  LoginState copyWith({
    Email email,
    Password password,
    AuthStatus status,
    FormzStatus formzStatus,
  }) {
    return LoginState(
      email: email ?? this.email,
      password: password ?? this.password,
      status: status ?? this.status,
      formzStatus: formzStatus ?? this.formzStatus,
    );
  }

  @override
  List<Object> get props => [email, password, status, formzStatus];
}
