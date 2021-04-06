import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/widgets.dart';

class SearchQuestionDropDown extends DevExamStatelessWidget {
  final Widget child;
  final double radius;
  final double horizontalPadding;

  SearchQuestionDropDown({
    Key key,
    @required this.child,
    this.radius = 20,
    this.horizontalPadding = 40,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) =>
      DecoratedBox(decoration: buildDecoration(context), child: buildChild());

  Padding buildChild() =>
      Padding(padding: EdgeInsets.symmetric(horizontal: horizontalPadding), child: child);

  ShapeDecoration buildDecoration(BuildContext context) {
    return ShapeDecoration(
      color: Colors.transparent,
      shape: RoundedRectangleBorder(
        side: BorderSide(
          width: 2,
          style: BorderStyle.solid,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? devExam.theme.accentTestPurple
              : devExam.theme.darkTestPurple,
        ),
        borderRadius: BorderRadius.all(Radius.circular(radius)),
      ),
    );
  }
}
