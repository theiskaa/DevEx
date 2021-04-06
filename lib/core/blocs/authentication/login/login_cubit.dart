import 'package:bloc/bloc.dart';
import 'package:devexam/core/services/fire_auth_service.dart';
import 'package:devexam/core/services/local_db_service.dart';
import 'package:devexam/core/utils/fire_exception_hander.dart';
import 'package:devexam/core/utils/validators.dart';
import 'package:equatable/equatable.dart';
import 'package:formz/formz.dart';


part 'login_state.dart';

enum SuggestionActStatus { Success, Erro, Undefined }

class LoginCubit extends Cubit<LoginState> {
  final FireAuthService fireAuthService;

  LoginCubit({
    this.fireAuthService,
  })  : assert(fireAuthService != null),
        super(const LoginState());

  void emailChanged(String value) {
    final email = Email.dirty(value);
    emit(state.copyWith(
      email: email,
      formzStatus: Formz.validate([email, state.password]),
    ));
    print("emailChanged ${state.email.status}");
  }

  void passwordChanged(String value) {
    final password = Password.dirty(value);
    emit(state.copyWith(
      password: password,
      formzStatus: Formz.validate([state.email, password]),
    ));
    print("passwordChanged ${state.email.status}");
  }

  Future<void> loginWEP(List<String> suggestions) async {
    if (!state.formzStatus.isValidated) return;
    emit(state.copyWith(
      status: AuthStatus.loading,
      formzStatus: FormzStatus.submissionInProgress,
    ));
    var result = await fireAuthService.logInWithEmailAndPassword(
      email: state.email.value,
      password: state.password.value,
    );
    // Save suggestion to local database.
    if (result == AuthStatus.successful) {
      final localDbService = await LocalDbService.instance;
      List<String> dbList = await localDbService.getDbList();
      if (dbList != suggestions) {
        return await localDbService.saveSuggestionList(suggestions);
      }
    }
    print(result);
    emit(state.copyWith(
      status: result,
      formzStatus: result == AuthStatus.successful
          ? FormzStatus.submissionSuccess
          : FormzStatus.submissionFailure,
    ));
  }
}
