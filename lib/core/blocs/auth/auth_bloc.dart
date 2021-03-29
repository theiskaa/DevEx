import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

import '../../models/user.dart';
import '../../services/fire_auth_service.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final FireAuthService _fireAuthService;
  StreamSubscription<UserModel> _userSubscription;

  AuthBloc({
    @required FireAuthService fireAuthService,
  })  : assert(fireAuthService != null),
        _fireAuthService = fireAuthService,
        super(const AuthState.unknown()) {
    _userSubscription = _fireAuthService.user.listen(
      (user) => add(AuthUserChanged(user)),
    );
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthUserChanged) {
      yield _mapAuthenticationUserChangedToState(event);
    } else if (event is AuthLogoutRequested) {
      await _fireAuthService.logOut();
    }
  }

  @override
  Future<void> close() {
    _userSubscription?.cancel();
    return super.close();
  }

  AuthState _mapAuthenticationUserChangedToState(
    AuthUserChanged event,
  ) {
    return event.user != UserModel.empty
        ? AuthState.authed(event.user)
        : const AuthState.unauthed();
  }
}
