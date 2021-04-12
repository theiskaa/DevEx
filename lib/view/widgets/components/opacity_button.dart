import 'package:flutter/material.dart';

/// **Usage:**
/// ```dart
///  OpacityButton(
///    child:  Image.network("https://picsum.photos/200/300"),
///    opacityValue: .3,
///    onTap: () => print("Tapped"),
///    onLongPress: () => print("long pressed"),
///  );
/// ```
/// You can't go blank [child] property, it's required.
/// `opacityValue`: is 0.5 as default, if you wanna change
/// it to your custom value, then should use it.
///
/// `onTap` and `onLongPress` is not required but should be use :)
///
class OpacityButton extends StatefulWidget {
  /// Gets a widget that the child element will build on the button
  final Widget child;

  /// The opacity value means, how opaque the button will be when pressed.
  ///
  /// As default it's opacityValue equals 0.5
  final double opacityValue;

  /// A tap with a primary button has occurred.
  ///
  /// This triggers when the tap gesture wins. If the tap gesture did not win,
  /// [onTapCancel] is called instead.
  /// that's means opacity value will decrease to one, ie zero
  final VoidCallback onTap;

  final bool enableOnLongPress;
  //
  /// Called when a long press gesture with a primary button has been recognized.
  ///
  /// Triggered when a pointer has remained in contact with the screen at the
  /// same location for a long period of time.
  ///
  /// When this happens, the opacity value will decrease to the value you define
  /// or the to the default value.
  final VoidCallback onLongPress;

  /// Whether the semantic information of the children is always included.
  ///
  /// Defaults to `false`.
  ///
  /// When true, regardless of the opacity settings the child semantic information is exposed as if the widget were fully visible.
  /// This is useful in cases where labels may be hidden during animations that would otherwise contribute relevant semantics.[alwaysIncludeSemantics] defaultly was setted to `false`
  /// if user wanna change it to `true` then should use it.
  final bool alwaysIncludeSemantics;

  const OpacityButton({
    Key key,
    @required this.child,
    this.opacityValue = .5,
    this.onTap,
    this.enableOnLongPress = false,
    this.onLongPress,
    this.alwaysIncludeSemantics,
  }) : super(key: key);

  @override
  _OpacityButtonState createState() => _OpacityButtonState();
}

class _OpacityButtonState extends State<OpacityButton> {
  bool _isTapped = false;

  // Change value of [_isTapped] to `true`.
  void _setToTrue() => setState(() => _isTapped = true);

  // Change value of [_isTapped] to `false`.
  void _setToFalse() => setState(() => _isTapped = false);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      // Listen user's [touching/tapingDown] to button and change [_isTapped] with `true`.
      onTapDown: (_) => (widget.onTap != null) ? _setToTrue() : null,

      // Listen user's [touching/tapingCancel] and change [_isTapped] with `false`.
      onTapCancel: () => (widget.onTap != null) ? _setToFalse() : null,

      // Listen user's [touching/tapingUp], change [_isTapped] with `false`.
      // And run [onTap] function.
      onTapUp: (_) {
        if (widget.onTap != null) {
          _setToFalse();
          return widget.onTap();
        }
      },

      // When Long Press Start set [_isTapped] to true.
      onLongPressStart: (_) => _setToTrue(),

      // When Long press end, set [_isTapped] to false & call [onLongPress] function.
      onLongPressEnd: (_) {
        if (widget.enableOnLongPress) {
          _setToFalse();
          return widget.onLongPress();
        } else {
          _setToFalse();
          return widget.onTap();
        }
      },

      child: _buttonBody(),
    );
  }

  // The body of [OpacityButton].
  Opacity _buttonBody() => Opacity(
        opacity: _opacityValue,
        child: widget.child,
        alwaysIncludeSemantics: (widget.alwaysIncludeSemantics != null)
            ? widget.alwaysIncludeSemantics
            : false,
      );

  // Get right opacity value by listening value of [_isTapped].
  double get _opacityValue => _isTapped ? widget.opacityValue : 1;
}
