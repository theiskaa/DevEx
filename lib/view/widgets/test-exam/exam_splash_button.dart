import 'package:devexam/core/blocs/theme/theme_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../components/widgets.dart';

class ExamSplashButton extends DevExamStatelessWidget {
  final String title;
  final Function onPress;
  final bool disabled;

  ExamSplashButton({
    Key key,
    this.onPress,
    this.title,
    this.disabled = false,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return AnimePressButton(
      disabled: disabled,
      title: title,
      onTap: onPress,
      size: 110,
      borderRadius: BorderRadius.circular(20),
    );
  }
}

/// The main class for [ExamSplashButton].
class AnimePressButton extends DevExamStatefulWidget {
  final Function onTap;
  final String title;
  final Duration duration;
  //final Curve curve;
  final double size;
  final BorderRadius borderRadius;
  final List<BoxShadow> boxShadow;
  final Color color;
  final bool wGradient;
  final List<Color> gradientColors;
  final Alignment beginGradient;
  final Alignment endGradient;
  final Color titleColor;
  final double titleSize;
  final FontWeight fontWeight;
  final bool disabled;

  AnimePressButton({
    @required this.onTap,
    @required this.title,
    this.duration,
    //this.curve,
    this.size,
    this.borderRadius,
    this.boxShadow,
    this.color,
    this.wGradient,
    this.gradientColors,
    this.beginGradient,
    this.endGradient,
    this.titleColor,
    this.titleSize,
    this.fontWeight,
    this.disabled = false,
  });

  @override
  _AnimePressButtonState createState() => _AnimePressButtonState();
}

class _AnimePressButtonState extends DevExamState<AnimePressButton>
    with SingleTickerProviderStateMixin {
  double _scale;
  AnimationController _animationController;
  //Animation curve;

  @override
  void initState() {
    _animationController = AnimationController(
      vsync: this,
      duration: (widget.duration != null)
          ? widget.duration
          : Duration(milliseconds: 200),
      lowerBound: 0,
      upperBound: 0.1,
    );

    _animationController.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    _scale = 1 - _animationController.value;
    return GestureDetector(
      onTapDown: (details) {
        if (widget.disabled == false) return _animationController.forward();
      },
      onTapCancel: () {
        if (widget.disabled == false) return _animationController.reverse();
      },
      onTapUp: (details) {
        if (widget.disabled == false) {
          _animationController.reverse();
          widget.onTap();
        }
      },
      child: Transform.scale(
        scale: _scale,
        child: Opacity(
          child: buttonBody(),
          opacity: widget.disabled ? 0.35 : 1,
        ),
      ),
    );
  }

  Widget buttonBody() {
    return Container(
      height: (widget.size != null) ? widget.size / 2.3 : 70,
      width: (widget.size != null) ? widget.size : 200,

      ///
      decoration: boxDecoration(),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: (widget.titleSize != null) ? widget.titleSize : 20,
            fontWeight: (widget.fontWeight != null)
                ? widget.fontWeight
                : FontWeight.w500,
            color: (widget.titleColor != null) ? widget.titleColor : null,
            // : BlocProvider.of<ThemeBloc>(context).state.themeData ==
            //         devExam.theme.dark
            //     ? Colors.white
            //     : Colors.black,
          ),
        ),
      ),
    );
  }

  BoxDecoration boxDecoration() {
    return BoxDecoration(
      color: (widget.color != null)
          ? widget.color
          : BlocProvider.of<ThemeBloc>(context).state.themeData ==
                  devExam.theme.dark
              ? Colors.black
              : Colors.white,
      borderRadius: (widget.borderRadius != null)
          ? widget.borderRadius
          : BorderRadius.circular(10),
      boxShadow: (widget.boxShadow != null)
          ? widget.boxShadow
          : [
              BlocProvider.of<ThemeBloc>(context).state.themeData ==
                      devExam.theme.dark
                  ? BoxShadow(
                      blurRadius: 5.0,
                      color: Colors.white.withOpacity(.2),
                      offset: Offset(0.0, 3.0),
                    )
                  : BoxShadow(
                      blurRadius: 12.0,
                      offset: Offset(0.0, 5.0),
                    ),
            ],

      ///
      gradient: (widget.wGradient == true)
          ? (widget.gradientColors != null)
              ? LinearGradient(
                  colors: widget.gradientColors,
                  begin: (widget.beginGradient != null)
                      ? widget.beginGradient
                      : Alignment.topRight,
                  end: (widget.endGradient != null)
                      ? widget.beginGradient
                      : Alignment.bottomLeft,
                )
              : LinearGradient(
                  begin: Alignment.topRight,
                  end: Alignment.bottomLeft,
                  colors: [
                    Colors.blue,
                    Color(0xff4267B2).withOpacity(.7),
                  ],
                )
          : null,

      ///
    );
  }
}
