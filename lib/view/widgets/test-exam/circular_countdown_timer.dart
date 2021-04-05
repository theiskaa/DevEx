import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../components/widgets.dart';

class CircularCountDownTimer extends DevExamStatefulWidget {
  final Key key;

  final Color fillColor;

  final Color color;

  final Color backgroundColor;

  final VoidCallback onComplete;

  final VoidCallback onStart;

  final int duration;

  final double width;

  final double height;

  final double strokeWidth;

  final StrokeCap strokeCap;

  final TextStyle textStyle;

  final String textFormat;

  final bool isReverse;

  final bool isReverseAnimation;

  final bool isTimerTextShown;

  final CountDownController controller;

  final bool autoStart;

  CircularCountDownTimer(
      {@required this.width,
      @required this.height,
      @required this.duration,
      @required this.fillColor,
      @required this.color,
      this.backgroundColor,
      this.isReverse = false,
      this.isReverseAnimation = false,
      this.onComplete,
      this.onStart,
      this.strokeWidth,
      this.strokeCap,
      this.textStyle,
      this.key,
      this.isTimerTextShown = true,
      this.autoStart = true,
      this.textFormat,
      this.controller})
      : assert(width != null),
        assert(height != null),
        assert(duration != null),
        assert(fillColor != null),
        assert(color != null),
        super(key: key);

  @override
  CircularCountDownTimerState createState() => CircularCountDownTimerState();
}

class CircularCountDownTimerState extends DevExamState<CircularCountDownTimer>
    with TickerProviderStateMixin {
  AnimationController _controller;
  Animation<double> _countDownAnimation;

  String get time {
    if (widget.isReverse && _controller.isDismissed) {
      if (widget.textFormat == CountdownTextFormat.MM_SS) {
        return "";
      } else if (widget.textFormat == CountdownTextFormat.SS) {
        return " ";
      } else {
        return " ";
      }
    } else {
      Duration duration = _controller.duration * _controller.value;
      return _getTime(duration);
    }
  }

  void _setAnimation() {
    if (widget.autoStart) {
      if (widget.isReverse) {
        _controller.reverse(from: 1);
      } else {
        _controller.forward();
      }
    }
  }

  void _setAnimationDirection() {
    if ((!widget.isReverse && widget.isReverseAnimation) ||
        (widget.isReverse && !widget.isReverseAnimation)) {
      _countDownAnimation =
          Tween<double>(begin: 1, end: 0).animate(_controller);
    }
  }

  void _setController() {
    widget.controller?._state = this;
    widget.controller?._isReverse = widget.isReverse;
  }

  String _getTime(Duration duration) {
    if (widget.textFormat == CountdownTextFormat.HH_MM_SS) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (widget.textFormat == CountdownTextFormat.MM_SS) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (widget.textFormat == CountdownTextFormat.SS) {
      return '${(duration.inSeconds)}';
    } else {
      return _defaultFormat(duration);
    }
  }

  _defaultFormat(Duration duration) {
    if (duration.inHours != 0) {
      return '${duration.inHours.toString().padLeft(2, '0')}:${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else if (duration.inMinutes != 0) {
      return '${(duration.inMinutes % 60).toString().padLeft(2, '0')}:${(duration.inSeconds % 60).toString().padLeft(2, '0')}';
    } else {
      return '${duration.inSeconds % 60}';
    }
  }

  void _onStart() {
    if (widget.onStart != null) widget.onStart();
  }

  void _onComplete() {
    if (widget.onComplete != null) widget.onComplete();
  }

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: Duration(seconds: widget.duration),
    );

    _controller.addStatusListener((status) {
      switch (status) {
        case AnimationStatus.forward:
          _onStart();
          break;

        case AnimationStatus.reverse:
          _onStart();
          break;

        case AnimationStatus.dismissed:
          _onComplete();
          break;
        case AnimationStatus.completed:
          if (!widget.isReverse) _onComplete();
          break;
        default:
      }
    });

    _setAnimation();
    _setAnimationDirection();
    _setController();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: widget.width,
      height: widget.height,
      child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return Align(
              child: AspectRatio(
                aspectRatio: 1.0,
                child: Stack(
                  children: <Widget>[
                    Positioned.fill(
                      child: CustomPaint(
                        painter: CustomTimerPainter(
                            animation: _countDownAnimation ?? _controller,
                            fillColor: widget.fillColor,
                            color: widget.color,
                            strokeWidth: widget.strokeWidth,
                            strokeCap: widget.strokeCap,
                            backgroundColor: widget.backgroundColor),
                      ),
                    ),
                    widget.isTimerTextShown
                        ? Align(
                            alignment: FractionalOffset.center,
                            child: Text(
                              time,
                              style: widget.textStyle ??
                                  TextStyle(
                                    fontSize: 16.0,
                                    color: Colors.black,
                                  ),
                            ),
                          )
                        : Container(),
                  ],
                ),
              ),
            );
          }),
    );
  }

  @override
  void dispose() {
    _controller.stop();
    _controller.dispose();
    super.dispose();
  }
}

class CountDownController {
  CircularCountDownTimerState _state;
  bool _isReverse;

  void start() {
    if (_isReverse) {
      _state._controller?.reverse(from: 1);
    } else {
      _state._controller?.forward(from: 0);
    }
  }

  void pause() {
    _state._controller?.stop(canceled: false);
  }

  void resume() {
    if (_isReverse) {
      _state._controller?.reverse(from: _state._controller.value);
    } else {
      _state._controller?.forward(from: _state._controller.value);
    }
  }

  void restart({int duration}) {
    _state._controller.duration =
        Duration(seconds: duration ?? _state._controller.duration.inSeconds);
    if (_isReverse) {
      _state._controller?.reverse(from: 1);
    } else {
      _state._controller?.forward(from: 0);
    }
  }

  String getTime() {
    return _state
        ._getTime(_state._controller.duration * _state._controller?.value);
  }
}

class CountdownTextFormat {
  static const String HH_MM_SS = "HH:mm:ss";
  static const String MM_SS = "mm:ss";
  static const String SS = "ss";
}

class CustomTimerPainter extends CustomPainter {
  CustomTimerPainter({
    this.animation,
    this.fillColor,
    this.color,
    this.strokeWidth,
    this.strokeCap,
    this.backgroundColor,
  }) : super(repaint: animation);

  final Animation<double> animation;
  final Color fillColor, color, backgroundColor;
  final double strokeWidth;
  final StrokeCap strokeCap;

  @override
  void paint(Canvas canvas, Size size) {
    Paint paint = Paint()
      ..color = color
      ..strokeWidth = strokeWidth ?? 5.0
      ..strokeCap = strokeCap ?? StrokeCap.butt
      ..style = PaintingStyle.stroke;

    canvas.drawCircle(size.center(Offset.zero), size.width / 2, paint);
    double progress = (animation.value) * 2 * math.pi;
    paint.color = fillColor;
    canvas.drawArc(Offset.zero & size, math.pi * 1.5, progress, false, paint);

    if (backgroundColor != null) {
      final backgroundPaint = Paint();
      backgroundPaint.color = backgroundColor;
      canvas.drawCircle(
          size.center(Offset.zero), size.width / 2.2, backgroundPaint);
    }
  }

  @override
  bool shouldRepaint(CustomTimerPainter old) {
    return animation.value != old.animation.value ||
        color != old.color ||
        fillColor != old.fillColor;
  }
}
