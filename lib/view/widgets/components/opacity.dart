import 'package:flutter/material.dart';

import 'widgets.dart';

class OpacityDoer extends DevExamStatelessWidget {
  final Widget child;
  final Duration duration;

  OpacityDoer({
    Key key,
    this.child,
    this.duration,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TweenAnimationBuilder(
      tween: Tween<double>(begin: 0.5, end: 1),
      duration: (duration != null) ? duration : Duration(seconds: 1),
      builder: (BuildContext context, double value, Widget child) => Opacity(
        opacity: value,
        child: child,
      ),
      child: child,
    );
  }
}
