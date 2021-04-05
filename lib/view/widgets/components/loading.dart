import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';

import 'widgets.dart';

class Loading extends DevExamStatelessWidget {
  Loading({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: buildAppBar(context),
      body: buildLoading(context),
    );
  }

  Center buildLoading(BuildContext context) {
    return Center(
      child: SpinKitSquareCircle(
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white
            : Colors.black,
        size: 70,
      ),
    );
  }

  AppBar buildAppBar(BuildContext context) {
    return AppBar(
      elevation: 0,
      backgroundColor: Colors.transparent,
      leading: OpacityButton(
        opacityValue: .3,
        child: Icon(
          Icons.arrow_back_ios,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.white
              : Colors.black,
        ),
        onTap: () => Navigator.pop(context),
      ),
    );
  }
}
