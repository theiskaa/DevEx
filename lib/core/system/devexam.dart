import 'intl.dart';
import 'log.dart';
import 'themes.dart';
import 'package:flutter/foundation.dart' show immutable;

/// The main singleton of the project.
/// it able to set otomaticly by using [DevExamStatlessWidegt] or [DevExamStatefulWidget].
class DevExam {
  static final DevExam _singleton = DevExam._internal();

  final Map<String, dynamic> instances = {};

  factory DevExam() {
    return _singleton;
  }

  DevExam._internal() {
    Log.v("${this.runtimeType.toString()} instance created");
  }

  // Make able to use themes everywhere.
  // If your page were wrapped with [DevExamStatlessWidegt] or [DevExamStatefulWidget].
  set theme(Themes themes) => this.instances["themes"] = themes;
  Themes get theme => this.instances["themes"];

  // Make able to use Intl (Localizations) everywhere.
  // If your page were wrapped with [DevExamStatlessWidegt] or [DevExamStatefulWidget].
  set intl(Intl intl) => this.instances["intl"] = intl;
  Intl get intl => this.instances["intl"];
}

@immutable
abstract class DevExModel {
  // Constructor for setting data.
  const DevExModel();

  // Set data from jsonDecode.
  const DevExModel.fromJson(Map<String, dynamic> json);

  // Get data to json format.
  Map<String, dynamic> toJson();
}

typedef S ItemCreator<S>();
