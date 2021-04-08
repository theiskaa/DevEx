import 'package:flutter/material.dart';

class FlutterTextButton extends StatefulWidget {
  /// The maint point of button,
  /// So everything would build on [title]
  final String title;

  /// The method wich would call in [onTapUp]
  final VoidCallback onTap;

  /// when [wOpacity] equals true, then Opacity widget would be enabled.
  /// and [opacityValue] would be able to usage.
  final bool wOpacity;

  /// In default [opacityValue] equals [.5], user can customize it.
  /// and this propertys usage is dependent by [wOpacity].
  final double opacityValue;

  /// In default size of [FlutterTextButton] is [20]
  /// And user can customize it by using [defaultSize] property.
  final double defaultSize;

  /// In default [tappedSize] of [FlutterTextButton] is [18]
  /// And user can customize it by using [tappedSize] property.
  final double tappedSize;

  // As default titleColor is black
  /// user can customize it by set custom color with [titleColor] property
  final Color titleColor;

  /// As default [titleWeight] is [FontWeight.w500]
  /// user can customize it by set custom weight with [titleWeight] property
  final FontWeight titleWeight;

  // To move title around the screen
  final TextAlign titleAlign;

  // Custom font property.
  final String fontFamily;

  /// As default [FlutterTextButton] doesn't use animation.
  /// But user can enable it and start using
  final bool wAnimation;

  /// As default duration equals [milliseconds: 300],
  /// and user can customize it by [duration] property.
  final Duration duration;

  // To localization title.
  final Locale titleLocale;

  FlutterTextButton({
    Key key,

    /// can't go blank [title] property
    @required this.title,

    /// can't go blank [onTap] property
    @required this.onTap,

    // * The use of these properties is user dependent.
    this.wOpacity,
    this.opacityValue,
    this.defaultSize,
    this.tappedSize,
    this.titleColor,
    this.titleWeight,
    this.titleAlign,
    this.fontFamily,
    this.wAnimation,
    this.duration,
    this.titleLocale,
  }) : super(key: key);

  @override
  _FlutterTextButtonState createState() => _FlutterTextButtonState();
}

class _FlutterTextButtonState extends State<FlutterTextButton>
    with SingleTickerProviderStateMixin {
  // For manage/animate size of button.
  AnimationController _animationController;

  Animation<double> _sizeAnimation;

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: (widget.duration != null)
          ? widget.duration
          : Duration(milliseconds: 300),
    );

    _sizeAnimation = Tween<double>(
      begin: (widget.defaultSize != null) ? widget.defaultSize : 20,
      end: (widget.tappedSize != null) ? widget.tappedSize : 18,
    ).animate(_animationController);

    _animationController.addListener(() {
      setState(() {});
    });
  }

  bool _isTapped = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      /// When you tap the button [_isTapped] would be [true] so pressed,
      onTapDown: (d) => getTrueOnTapDown(),

      /// When cancel tapping the button [_isTapped] would be [false] so canceled,
      onTapCancel: () => getTrueOnTapCancel(),

      /// When you remove your finget on the button [_isTapped] would be [false] so didn't pressed,
      onTapUp: (d) => getTrueOnTapUp(),

      // The right child by following properties.
      child: getTrueTitle(),
    );
  }

  /// the right method for [onTapDown],
  /// Getting by following [wAnimation].
  getTrueOnTapDown() {
    if (widget.wAnimation != null && widget.wAnimation != false) {
      _animationController.forward();
    } else {
      setState(() {
        _isTapped = true;
      });
    }
  }

  /// the right method for [onTapCancel],
  /// Getting by following [wAnimation].
  getTrueOnTapCancel() {
    if (widget.wAnimation != false && widget.wAnimation != null) {
      _animationController.reverse();
    } else {
      setState(() {
        _isTapped = false;
      });
    }
  }

  /// the right method for [onTapUp],
  /// Getting by following [wAnimation].
  getTrueOnTapUp() {
    if (widget.wAnimation != false && widget.wAnimation != null) {
      _animationController.reverse();
      widget.onTap();
    } else {
      setState(() {
        _isTapped = false;
      });
      widget.onTap();
    }
  }

  /// the right title widget for button's child.
  /// Getting by following [wAnimation] and [wOpacity].
  Widget getTrueTitle() {
    if (widget.wAnimation != false && widget.wAnimation != null) {
      return animatedTitle();
    } else {
      if (widget.wOpacity != false && widget.wOpacity != null) {
        return Opacity(
          opacity: _isTapped
              ? (widget.opacityValue == null)
                  ? .5
                  : widget.opacityValue
              : 1,
          child: title(),
        );
      } else {
        return title();
      }
    }
  }

  /// Title prepared by [AnimatedBuilder].
  /// Make usable when [wAnimation] is equals true.
  Widget animatedTitle() {
    return AnimatedBuilder(
      animation: _animationController,
      builder: (context, child) => Text(
        widget.title,
        textAlign:
            (widget.titleAlign != null) ? widget.titleAlign : TextAlign.center,
        style: TextStyle(
          locale: widget.titleLocale,
          fontSize: _sizeAnimation.value,
          color: (widget.titleColor != null) ? widget.titleColor : Colors.black,
          fontWeight: (widget.titleWeight != null)
              ? widget.titleWeight
              : FontWeight.w500,
          fontFamily: widget.fontFamily,
        ),
      ),
    );
  }

  /// Default title widget
  Widget title() {
    return Text(
      widget.title,
      textAlign:
          (widget.titleAlign != null) ? widget.titleAlign : TextAlign.center,
      style: TextStyle(
        fontSize: _isTapped
            ? (widget.tappedSize != null)
                ? widget.tappedSize
                : 18
            : (widget.defaultSize != null)
                ? widget.defaultSize
                : 20,
        color: (widget.titleColor != null) ? widget.titleColor : Colors.black,
        fontWeight:
            (widget.titleWeight != null) ? widget.titleWeight : FontWeight.w500,
        fontFamily: widget.fontFamily,
      ),
    );
  }
}
