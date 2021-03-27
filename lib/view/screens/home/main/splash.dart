import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../../../widgets/components/widgets.dart';

class Splash extends DevExamStatelessWidget {
  Splash({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    //
    SystemChrome.setPreferredOrientations(
      [
        DeviceOrientation.portraitDown,
        DeviceOrientation.portraitUp,
      ],
    );
    //
    return Container(color: Colors.white);
  }
}
