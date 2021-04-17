import 'package:flutter/material.dart';

import '../components/widgets.dart';

class CustomAuthButton extends DevExamStatefulWidget {
  final String title;
  final double height;
  final double width;
  final VoidCallback onTap;
  final Color borderColor;
  final Color spashColor;
  final Color titleColor;
  final Color tappedTitleColor;
  final double titleSize;
  final FontWeight fontWeight;
  final BorderRadiusGeometry borderRadius;
  final Duration duration;
  final double borderWidth;

  CustomAuthButton({
    Key key,
    @required this.title,
    @required this.onTap,
    @required this.height,
    @required this.width,
    this.borderColor,
    this.spashColor,
    this.titleColor,
    this.tappedTitleColor,
    this.titleSize,
    this.borderRadius,
    this.fontWeight,
    this.duration,
    this.borderWidth,
  });

  @override
  _CustomAuthButtonState createState() => _CustomAuthButtonState();
}

class _CustomAuthButtonState extends DevExamState<CustomAuthButton>
    with SingleTickerProviderStateMixin {
  AnimationController _animationController;
  Animation<Color> _colorAnimation;
  Animation<Color> _textColorAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: (widget.duration != null)
          ? widget.duration
          : Duration(milliseconds: 300),
    );

    _colorAnimation = ColorTween(
      begin: Colors.transparent,
      end: (widget.spashColor != null) ? widget.spashColor : Colors.black,
    ).animate(_animationController);

    _textColorAnimation = ColorTween(
      begin: (widget.titleColor != null) ? widget.titleColor : Colors.black,
      end: (widget.tappedTitleColor != null)
          ? widget.tappedTitleColor
          : Colors.white,
    ).animate(_animationController);

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
      child: AnimatedBuilder(
        animation: _animationController,
        builder: (context, child) {
          return buildButton();
        },
      ),
    );
  }

  Container buildButton() {
    return Container(
      height: widget.height,
      width: widget.width,
      decoration: buildButtonDecoraiton(),
      child: Center(
        child: Text(
          widget.title,
          style: TextStyle(
            fontSize: widget.titleSize,
            color: _textColorAnimation.value,
            fontWeight: widget.fontWeight,
          ),
        ),
      ),
    );
  }

  BoxDecoration buildButtonDecoraiton() {
    return BoxDecoration(
      borderRadius: (widget.borderRadius == null)
          ? BorderRadius.circular(0)
          : widget.borderRadius,
      border: Border.all(
        width: (widget.borderWidth != null) ? widget.borderWidth : 2,
        color: (widget.borderColor != null) ? widget.borderColor : Colors.black,
      ),
      color: _colorAnimation.value,
    );
  }
}
