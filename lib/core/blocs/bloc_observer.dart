import 'package:bloc/bloc.dart';
import 'package:devexam/core/system/log.dart';

class SimpleBlocObserver extends BlocObserver {
  @override
  void onEvent(Bloc bloc, Object event) {
    Log.d("[ onEvent $event ]");
    super.onEvent(bloc, event);
  }

  @override
  onTransition(Bloc bloc, Transition transition) {
    Log.d("[ onTransition $transition ]");
    super.onTransition(bloc, transition);
  }

  @override
  void onError(Cubit cubit, Object error, StackTrace stackTrace) {
    Log.e(cubit, error, stackTrace);
    super.onError(cubit, error, stackTrace);
  }
}
