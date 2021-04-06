part of 'auth_bloc.dart';

enum AuthenticationStatus { authed, unauthed, unknown }

class AuthState extends Equatable {
  final AuthenticationStatus status;
  final UserModel user;
  const AuthState._({
    this.status = AuthenticationStatus.unknown,
    this.user = UserModel.empty,
  });

  const AuthState.unknown() : this._();

  const AuthState.authed(UserModel user)
      : this._(status: AuthenticationStatus.authed, user: user);

  const AuthState.unauthed() : this._(status: AuthenticationStatus.unauthed);

  @override
  List<Object> get props => [status, user];
}
