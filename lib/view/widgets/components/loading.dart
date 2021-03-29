import 'package:flutter/material.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'widgets.dart';

class Loading extends DevExamStatelessWidget {
  Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      backgroundColor: Colors.white,
      body: buildLoading(),
    );
  }

  Center buildLoading() {
    return Center(
      child: SpinKitSquareCircle(
        color: Colors.black,
        size: 70,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.white,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(Icons.arrow_back_ios, color: Colors.black),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
