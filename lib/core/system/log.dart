import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';
import 'package:logger/logger.dart';

/// logger for application
class Log {
  @visibleForTesting
  static final Logger log = Logger(
    level: getLevel(),
    output: ConsoleOutput(),
    printer: PrettyPrinter(
      printEmojis: false,
    ),
  );

  @visibleForTesting
  static final Logger logNoStack = Logger(
    level: getLevel(),
    output: ConsoleOutput(),
    printer: PrettyPrinter(
      printTime: false,
      printEmojis: false,
      methodCount: 0,
    ),
  );

  static String level;

  /// log a message at level verbose
  static Function get v => logNoStack.v;

  /// log a message at level debug
  static Function get d => logNoStack.d;

  /// log a message at level info
  static Function get i => logNoStack.i;

  /// log a message at level warning with stacktrace
  static Function get w => log.w;

  /// log a message at level error with stacktrace
  static Function get e => log.e;

  /// log a message at level critical with stacktrace
  static Function get c => log.wtf;

  // get log level [Level] by string
  @visibleForTesting
  static Level getLevel() {
    switch (level) {
      case 'verbose':
        return Level.verbose;
      case 'debug':
        return Level.debug;
      case 'info':
        return Level.info;
      case 'warning':
        return Level.warning;
      case 'error':
        return Level.error;
      case 'critical':
        return Level.wtf;
      default:
        return Level.verbose;
    }
  }
}

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) =>
      event.lines.forEach((line) => developer.log(line));
}
