import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

import '../../view/widgets/components/widgets.dart';

enum Device { Mobile, Tablet, Web }

/// Custom widget for make page responsive/perceptive.
class PerceptiveWidget extends DevExamStatelessWidget {
  /// Everything was building in this child property.
  /// So we must to provide it when we need use [PerceptiveWidget].
  final Widget child;

  PerceptiveWidget({
    Key key,
    @required this.child,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    /// `pG` instance of [PercentGenerator] to get call init method.
    PercentGenerator pG = PercentGenerator();
    return LayoutBuilder(
      key: key,
      builder: (context, boxConstraints) => OrientationBuilder(
        builder: (context, orientation) {
          /// call `init` to set the percent methods to right form.
          pG.init(orientation, boxConstraints);
          return child;
        },
      ),
    );
  }
}

extension DoublePerceptive on double {
  // Get height percent of the screen.
  double get hP => PercentGenerator.heightPercent(this);

  // Get width percent of the screen.
  double get wP => PercentGenerator.widthPercent(this);

  /// Get fontSize percent of the screen, by listening [width].
  double get fP => PercentGenerator.fontSizePercent(this);
}

class PercentGenerator {
  static Orientation _orientation;
  static Device _device;
  static var _height;
  static var _width;

  static get orientation => _orientation;

  static get device => _device;

  void init(Orientation orientation, BoxConstraints boxConstraints) {
    // Set orientation by default.
    _orientation = orientation;

    if (orientation != Orientation.portrait) {
      // Set values as opposites.
      _height = boxConstraints.maxWidth;
      _width = boxConstraints.maxHeight;
    } else {
      // Set values to right form.
      _height = boxConstraints.maxHeight;
      _width = boxConstraints.maxWidth;
    }

    /// Detect & Set type of Device. by listening width of screen.
    if (_width < 950) {
      _device = Device.Web;
    } else if (_width < 600) {
      _device = Device.Mobile;
    } else {
      _device = Device.Tablet;
    }
  }

  // Set value by listening screen's `height` and get percent of screen.
  static heightPercent(var v) {
    return _height * v / 100;
  }

  // Set value by listening screen's width and get percent of screen.
  static widthPercent(var v) {
    return _width * v / 100;
  }

  // Set value by listening screen's width and get percent of fontSize.
  static fontSizePercent(var v) {
    return _width / 100 * (v / 3);
  }
}
