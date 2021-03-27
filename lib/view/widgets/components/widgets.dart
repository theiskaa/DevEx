import 'package:flutter/widgets.dart';

import '../../../core/system/devexam.dart';

/// Custom [StatelessWidget] implemented [YHQ] singleton
abstract class DevExamStatelessWidget extends StatelessWidget {
  DevExamStatelessWidget({Key key}) : super(key: key);
  final DevExam devExam = DevExam();
}

/// Custom [StatefulWidget] implemented [YHQ] singleton
abstract class DevExamStatefulWidget extends StatefulWidget {
  DevExamStatefulWidget({Key key}) : super(key: key);
  final DevExam devExam = DevExam();
}

/// Custom [State] implemented [YHQ] singleton for [YHQStatefulWidget]
abstract class DevExamState<B extends DevExamStatefulWidget> extends State<B> {
  final DevExam devExam = DevExam();
}
