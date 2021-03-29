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

/*
extension IntPerceptive on int {
  // Get height percent of the screen to int.
  double get hP => PercentGenerator.heightPercentToInt(this).round();

  // Get width percent of the screen to int.
  double get wP => PercentGenerator.heightPercentToInt(this).round();

  /// Get fontSize percent of the screen, by listening [width] to int.
  double get fP => PercentGenerator.heightPercentToInt(this).round();
}
*/
class PercentGenerator {
  static Orientation _orientation;
  static Device _device;
  static var _height;
  static var _width;

  /// get `orientation` to use in other cases.
  static get orientation => _orientation;

  /// get `device` to use in other cases. for get type of clinet device.
  static get device => _device;

  void init(Orientation orientation, BoxConstraints boxConstraints) {
    // set orientation by default.
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

    /// Detect type of Device. by listening width of screen & setting [Device] enum.
    if (_width < 950) {
      _device = Device.Web;
    } else if (_width < 600) {
      _device = Device.Mobile;
    } else {
      _device = Device.Tablet;
    }
  }

  //* Set value by listening screen's `height` and get percent of screen.
  static heightPercent(var v) {
    return _height * v / 100;
  }

  //* Set value by listening screen's width and get percent of screen.
  static widthPercent(var v) {
    return _width * v / 100;
  }

  //* Set value by listening screen's width and get percent of fontSize.
  static fontSizePercent(var v) {
    return _width / 100 * (v / 3);
  }

  //* Set value by listening screen's `height` and get percent of screen.
  /*
  static heightPercentToInt(int v) {
    return (_height * v ~/ 100).toInt();
  }
  */

  //* Set value by listening screen's width and get percent of screen.
  /*
  static widthPercentToInt(int v) {
    return (_width * v ~/ 100).round();
  }
  */

  //* Set value by listening screen's width and get percent of fontSize.
  /*
  static fontSizePercentToInt(int v) {
    return (_width ~/ 100 * (v ~/ 3)).toInt();
  }
  */
}
