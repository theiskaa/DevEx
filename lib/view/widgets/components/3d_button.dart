import 'package:flutter/material.dart';

class StyleOf3dButton {
  final Color topColor;
  final Color backColor;
  final double width;
  final double height;
  final BorderRadius borderRadius;
  final double z;
  final double tapped;

  const StyleOf3dButton({
    this.width,
    this.height,
    this.topColor = const Color(0xFF45484c),
    this.backColor = const Color(0xFF191a1c),
    this.borderRadius = const BorderRadius.all(
      Radius.circular(7.0),
    ),
    this.z = 8.0,
    this.tapped = 3.0,
  });
  static const DEFAULT = const StyleOf3dButton(
    topColor: const Color(0xFFffffff),
    backColor: const Color(0xFFCFD8DC),
  );
}

class Button3D extends StatefulWidget {
  final VoidCallback onPressed;
  final Widget child;
  final StyleOf3dButton style;
  final double width;
  final double height;

  Button3D({
    @required this.onPressed,
    @required this.child,
    this.style = StyleOf3dButton.DEFAULT,
    this.width = 120,
    this.height = 60,
  });

  @override
  State<StatefulWidget> createState() => Button3DState();
}

class Button3DState extends State<Button3D> {
  bool isTapped = false;

  Widget _buildBackLayout() {
    return Padding(
      padding: EdgeInsets.only(top: widget.style.z),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          borderRadius: widget.style.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.style.backColor,
              offset: Offset(2, 0),
            )
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: widget.width,
            height: widget.height - widget.style.z,
          ),
        ),
      ),
    );
  }

  Widget _buildTopLayout() {
    return Padding(
      padding: EdgeInsets.only(
        top: isTapped ? widget.style.z - widget.style.tapped : 3,
      ),
      child: DecoratedBox(
        position: DecorationPosition.background,
        decoration: BoxDecoration(
          borderRadius: widget.style.borderRadius,
          boxShadow: [
            BoxShadow(
              color: widget.style.topColor,
            ),
          ],
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints.expand(
            width: widget.width,
            height: widget.height - widget.style.z,
          ),
          child: Container(
            padding: EdgeInsets.zero,
            alignment: Alignment.center,
            child: widget.child,
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Stack(
        alignment: AlignmentDirectional.topCenter,
        children: <Widget>[_buildBackLayout(), _buildTopLayout()],
      ),
      onTapDown: (TapDownDetails event) {
        setState(() {
          isTapped = true;
        });
      },
      onTapCancel: () {
        setState(() {
          isTapped = false;
        });
      },
      onTapUp: (TapUpDetails event) {
        setState(() {
          isTapped = false;
        });
        widget.onPressed();
      },
    );
  }
}
