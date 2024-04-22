import 'package:flutter/foundation.dart';

import '../util/log/src/logger.dart';
import '../util/log/src/printers/pretty_printer.dart';

class AppLog {
  static Logger loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static debug(dynamic message, {String tag = "Debug"}) {
    if (kDebugMode) {
      loggerNoStack.d(message, tag);
    }
  }

  static info(dynamic message, {String tag = "Info"}) {
    if (kDebugMode) {
      loggerNoStack.i(message, tag);
    }
  }

  static warning(dynamic message, {String tag = "Warning"}) {
    if (kDebugMode) {
      loggerNoStack.w(message, tag);
    }
  }

  static error(dynamic message, {String tag = "Error"}) {
    if (kDebugMode) {
      loggerNoStack.e(message, tag);
    }
  }

  static verbose(dynamic message, {String tag = "Verbose"}) {
    if (kDebugMode) {
      loggerNoStack.v(message, tag);
    }
  }
}
