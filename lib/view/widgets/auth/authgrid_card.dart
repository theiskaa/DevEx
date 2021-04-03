import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_button/flutter_button.dart';

import '../components/widgets.dart';

class AuthGridCard extends DevExamStatelessWidget {
  final List<Widget> fields;
  final Function onTapForSCB;
  final double height;
  final String titleOfSeccondTextButton;
  final Widget spacer;
  final bool wAnimation;
  final Color accentColor;
  final Color darkColor;

  AuthGridCard({
    Key key,
    @required this.fields,
    this.onTapForSCB,
    @required this.height,
    this.titleOfSeccondTextButton,
    @required this.accentColor,
    @required this.darkColor,
    this.wAnimation = false,
    this.spacer,
  });

  @override
  Widget build(BuildContext context) {
    return wAnimation
        ? buildAnimatedContainer(context)
        : buildDefaultContainer(context);
  }

  Container buildDefaultContainer(BuildContext context) {
    return Container(
      decoration: buildBoxDecoration(context),
      padding: EdgeInsets.all(16),
      height: height,
      width: MediaQuery.of(context).size.width - 30,
      child: Center(
        child: Column(
          children: [
            buildFieldsPlace(),
            (spacer != null) ? spacer : Spacer(),
            (titleOfSeccondTextButton == null)
                ? Container()
                : textButton(context),
          ],
        ),
      ),
    );
  }

  AnimatedContainer buildAnimatedContainer(BuildContext context) {
    return AnimatedContainer(
      duration: Duration(milliseconds: 300),
      decoration: buildBoxDecoration(context),
      padding: EdgeInsets.all(16),
      height: height,
      width: MediaQuery.of(context).size.width - 30,
      child: Center(
        child: Column(
          children: [
            buildFieldsPlace(),
            (spacer != null) ? spacer : Spacer(),
            (titleOfSeccondTextButton == null)
                ? Container()
                : textButton(context),
          ],
        ),
      ),
    );
  }

  Column buildFieldsPlace() => Column(
        children: fields,
        mainAxisAlignment: MainAxisAlignment.center,
      );

  Widget textButton(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(10),
      alignment: Alignment.bottomRight,
      child: FlutterTextButton(
        color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                devExam.theme.dark
            ? Colors.white
            : null,
        wOpacity: true,
        opacityValue: .5,
        defaultSize: 16,
        pressedSize: 15.5,
        title: titleOfSeccondTextButton,
        onTap: onTapForSCB,
      ),
    );
  }

  BoxDecoration buildBoxDecoration(BuildContext context) {
    return BoxDecoration(
      color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
              devExam.theme.dark
          ? Colors.black
          : Colors.white,
      border: Border.all(
        width: 0.1,
        color: darkColor,
      ),
      borderRadius: BorderRadius.circular(40),
      boxShadow: [
        BoxShadow(
          offset: Offset(0, 15),
          blurRadius: 15,
          color: BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? darkColor.withOpacity(.5)
              : darkColor,
        ),
      ],
    );
  }
}
