import 'package:bloc/bloc.dart';
import 'package:devexam/core/services/fire_auth_service.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

part 'register_state.dart';

class RegisterCubit extends Cubit<RegisterState> {
  final FireAuthService _fireAuthService;
  RegisterCubit(this._fireAuthService)
      : assert(_fireAuthService != null),
        super(const RegisterState());

  void usernameChanged(String value) {
    final username = Username.dirty(value);
    emit(
      state.copyWith(
        username: username,
        formzStatus: Formz.validate([
          username,
          state.email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        formzStatus: Formz.validate([
          state.username,
          email,
          state.password,
          state.confirmedPassword,
        ]),
      ),
    );
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    final confirmedPassword = ConfirmedPassword.dirty(
      password: password.value,
      value: state.confirmedPassword.value,
    );
    emit(state.copyWith(
      password: password,
      confirmedPassword: confirmedPassword,
      formzStatus: Formz.validate([
        state.username,
        state.email,
        state.password,
        state.confirmedPassword,
      ]),
    ));
  }

  void confirmedPasswordChanged(String value) {
    final confirmedPassword = ConfirmedPassword.dirty(
      password: state.password.value.trim(),
      value: value.trim(),
    );
    emit(
      state.copyWith(
        confirmedPassword: confirmedPassword,
        formzStatus: Formz.validate([
          state.username,
          state.email,
          state.password,
          confirmedPassword,
        ]),
      ),
    );
  }

  Future<void> registerWEP() async {
    if (!state.formzStatus.isValidated) return;
    emit(state.copyWith(
      status: AuthStatus.loading,
      formzStatus: FormzStatus.submissionInProgress,
    ));
    var result = await _fireAuthService.createUserWithEmailAndPassword(
      username: state.username.value,
      email: state.email.value,
      password: state.password.value,
    );
    print(result);
    emit(state.copyWith(
      status: result,
      formzStatus: result == AuthStatus.successful
          ? FormzStatus.submissionSuccess
          : FormzStatus.submissionFailure,
    ));
  }
}
