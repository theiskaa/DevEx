import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:devexam/core/services/local_db_service.dart';
import 'package:devexam/core/system/devexam.dart';
import 'package:equatable/equatable.dart';
import 'package:meta/meta.dart';

part 'designprefs_event.dart';
part 'designprefs_state.dart';

class DesignprefsBloc extends Bloc<DesignprefsEvent, DesignprefsState> {
  final DevExam devExam;

  DesignprefsBloc(this.devExam)
      : super(DesignprefsState(
          isScrollSearchEnabled: true,
          isFieldSearchEnabled: false,
        ));

  @override
  Stream<DesignprefsState> mapEventToState(
    DesignprefsEvent event,
  ) async* {
    DesignprefsState state;

    if (event is DecideDesignPrefs) {
      state = await _decide(state);
    }
    if (event is EnableScrollSearch) {
      state = DesignprefsState(isScrollSearchEnabled: true);

      try {
        state = await _switchScrollSearchEnabled(
          val: true,
          state: state,
        );
      } catch (e) {
        print("$e");
      }
    }

    if (event is DisbleScrollSearch) {
      state = DesignprefsState(isScrollSearchEnabled: false);

      try {
        state = await _switchScrollSearchEnabled(
          val: false,
          state: state,
        );
      } catch (e) {
        print("$e");
      }
    }

    if (event is EnableFieldSearch) {
      state = DesignprefsState(isFieldSearchEnabled: true);

      try {
        state = await _switchFieldSearchEnabled(
          val: true,
          state: state,
        );
      } catch (e) {
        print("$e");
      }
    }

    if (event is DisbleFieldSearch) {
      state = DesignprefsState(isFieldSearchEnabled: false);

      try {
        state = await _switchFieldSearchEnabled(
          val: false,
          state: state,
        );
      } catch (e) {
        print("$e");
      }
    }

    yield state;
  }
}

Future<DesignprefsState> _decide(DesignprefsState state) async {
  var db = await LocalDbService.instance;
  bool scrollSearchIsEnabled =
      await db.getValue(LocalDbKeys.scrollSearchEnabled);
  bool fieldSearchIsEnabled = await db.getValue(LocalDbKeys.fieldSearchEnabled);

  state = DesignprefsState(
    isScrollSearchEnabled: scrollSearchIsEnabled,
    isFieldSearchEnabled: fieldSearchIsEnabled,
  );

  return state;
}

Future<DesignprefsState> _switchScrollSearchEnabled({
  @required bool val,
  @required DesignprefsState state,
}) async {
  var db = await LocalDbService.instance;
  await db.setValue(LocalDbKeys.scrollSearchEnabled, val);

  if (val == false) {
    state = DesignprefsState(isScrollSearchEnabled: false);
  } else if (val == true) {
    state = DesignprefsState(isScrollSearchEnabled: true);
  }

  return state;
}

Future<DesignprefsState> _switchFieldSearchEnabled({
  @required bool val,
  @required DesignprefsState state,
}) async {
  var db = await LocalDbService.instance;
  await db.setValue(LocalDbKeys.fieldSearchEnabled, val);

  if (val == false) {
    state = DesignprefsState(isFieldSearchEnabled: false);
  } else if (val == true) {
    state = DesignprefsState(isFieldSearchEnabled: true);
  }

  return state;
}
