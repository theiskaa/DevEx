import 'package:flutter/material.dart';

class AnimatedFloatingActionButton extends StatefulWidget {
  final Function onTap;
  final Widget child;
  final Color backgroundColor;
  final bool wGradient;
  final double size;
  final double tappedSize;
  final BorderRadius borderRadius;
  final List<Color> gradientColors;
  final Duration duration;
  final bool wShadow;
  final List<BoxShadow> shadows;
  final BoxBorder border;

  const AnimatedFloatingActionButton({
    Key key,
    @required this.child,
    @required this.onTap,
    this.backgroundColor,
    this.wGradient,
    this.size,
    this.tappedSize,
    this.borderRadius,
    this.gradientColors,
    this.duration,
    this.wShadow,
    this.shadows,
    this.border,
  }) : super(key: key);

  @override
  _AnimatedFloatingActionButtonstate createState() =>
      _AnimatedFloatingActionButtonstate();
}

class _AnimatedFloatingActionButtonstate
    extends State<AnimatedFloatingActionButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: (widget.duration != null)
          ? widget.duration
          : Duration(milliseconds: 250),
    );

    _sizeAnimation = TweenSequence(<TweenSequenceItem<double>>[
      TweenSequenceItem(
        tween: Tween<double>(
          begin: (widget.size != null) ? widget.size : 60,
          end: (widget.tappedSize != null) ? widget.tappedSize : 55,
        ),
        weight: (widget.size != null) ? widget.size : 60,
      ),
    ]).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTapDown: (details) {
        _animationController.forward();
      },
      onTapCancel: () {
        _animationController.reverse();
      },
      onTapUp: (details) {
        _animationController.reverse();
        widget.onTap();
      },
      child: Container(
        height: _sizeAnimation.value,
        width: _sizeAnimation.value,
        decoration: buildBoxDecoration(),
        child: widget.child,
      ),
    );
  }

  BoxDecoration buildBoxDecoration() {
    return BoxDecoration(
      color: (widget.backgroundColor != null)
          ? widget.backgroundColor
          : Colors.blue,
      borderRadius: (widget.borderRadius != null)
          ? widget.borderRadius
          : BorderRadius.circular(100),
      gradient: (widget.wGradient == false || widget.wGradient == null)
          ? null
          : LinearGradient(colors: widget.gradientColors),
      boxShadow: (widget.wShadow != null || widget.wShadow != false)
          ? widget.shadows
          : null,
      border: (widget.border != null) ? widget.border : null,
    );
  }
}



class CustomFAB extends StatelessWidget {
  final Function onTap;
  final Widget child;
  final Color backgroundColor;
  final double elevation;
  final Color hoverColor;
  final Color splashColor;
  final double bottomLeftRadius;
  final double bottomRightRadius;
  final double topLeftRadius;
  final double topRightRadius;
  final BorderSide border;
  const CustomFAB({
    Key key,
    @required this.child,
    @required this.onTap,
    this.backgroundColor,
    this.elevation,
    this.hoverColor,
    this.splashColor,
    this.bottomLeftRadius,
    this.bottomRightRadius,
    this.topLeftRadius,
    this.topRightRadius,
    this.border,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      hoverColor: hoverColor,
      splashColor: splashColor,
      onPressed: onTap,
      elevation: elevation,
      backgroundColor: backgroundColor,
      child: child,
      shape: buildShape(),
    );
  }

  RoundedRectangleBorder buildShape() {
    return RoundedRectangleBorder(
      side: (border != null) ? border : BorderSide.none,
      borderRadius: BorderRadius.only(
        bottomLeft: Radius.circular(
          (bottomLeftRadius != null) ? bottomLeftRadius : 10,
        ),
        bottomRight: Radius.circular(
          (bottomRightRadius != null) ? bottomRightRadius : 10,
        ),
        topLeft: Radius.circular(
          (topLeftRadius != null) ? topLeftRadius : 10,
        ),
        topRight: Radius.circular(
          (topRightRadius != null) ? topRightRadius : 10,
        ),
      ),
    );
  }
}