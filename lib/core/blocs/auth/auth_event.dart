part of 'auth_bloc.dart';

abstract class AuthEvent extends Equatable {
  const AuthEvent();

  @override
  List<Object> get props => [];
}

class AuthUserChanged extends AuthEvent {
  const AuthUserChanged(this.user);

  final UserModel user;

  @override
  List<Object> get props => [user];
}

class AuthLogoutRequested extends AuthEvent {}
