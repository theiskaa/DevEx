import 'intl.dart';
import 'log.dart';
import 'themes.dart';
import 'package:flutter/foundation.dart' show immutable;

class DevExam {
  static final DevExam _singleton = DevExam._internal();

  final Map<String, dynamic> instances = {};
  // Env env;

  factory DevExam() {
    return _singleton;
  }

  DevExam._internal() {
    Log.v("${this.runtimeType.toString()} instance created");
  }

  set theme(Themes themes) => this.instances["themes"] = themes;
  Themes get theme => this.instances["themes"];

  set intl(Intl intl) => this.instances["intl"] = intl;
  Intl get intl => this.instances["intl"];
}

@immutable
abstract class DevExModel {
  // constructor for setting data
  const DevExModel();

  // set data from jsonDecode
  const DevExModel.fromJson(Map<String, dynamic> json);

  // get data to json format
  Map<String, dynamic> toJson();
}

typedef S ItemCreator<S>();
