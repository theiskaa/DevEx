
import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';

import '../../services/user_service.dart';
import '../../utils/fire_exception_hander.dart';
import '../../utils/validators.dart';

part 'resetpassword_state.dart';

class ResetpasswordCubit extends Cubit<ResetpasswordState> {
  final UserServices userServices;
  ResetpasswordCubit(this.userServices)
      : assert(userServices != null),
        super(ResetpasswordState());

  Future<void> emailChanged(String value) async {
    final email = Email.dirty(value);
    emit(
      state.copyWith(
        email: email,
        formzStatus: Formz.validate([email]),
      ),
    );
  }

  Future<void> newPasswordChanged(String value) async {
    final newPassword = Password.dirty(value);
    emit(
      state.copyWith(
        newPassword: newPassword,
        formzStatus: Formz.validate([newPassword]),
      ),
    );
  }

  Future<void> changePassword({
    String uid,
    String newPassword,
  }) async {
    if (!state.formzStatus.isValidated) return;
    emit(state.copyWith(
      status: AuthStatus.loading,
      formzStatus: FormzStatus.submissionInProgress,
    ));
    var result = await userServices.changePassword(
      uid: uid,
      newPassword: newPassword,
    );
    print(result);
    emit(state.copyWith(
      status: result,
      formzStatus: result == AuthStatus.successful
          ? FormzStatus.submissionSuccess
          : FormzStatus.submissionFailure,
    ));
  }

  Future<void> sendResetPasswordMail() async {
    if (!state.formzStatus.isValidated) return;
    emit(state.copyWith(
      status: AuthStatus.loading,
      formzStatus: FormzStatus.submissionInProgress,
    ));
    var result = await userServices.sendPasswordResetMail(state.email.value);
    print(result);
    emit(state.copyWith(
      status: result,
      formzStatus: result == AuthStatus.successful
          ? FormzStatus.submissionSuccess
          : FormzStatus.submissionFailure,
    ));
  }
}

