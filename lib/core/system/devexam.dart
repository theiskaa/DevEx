import 'intl.dart';
import 'log.dart';
import 'themes.dart';

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
