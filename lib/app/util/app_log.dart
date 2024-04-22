import '../../build_constants.dart';
import 'log/logger.dart';

class AppLog {
  static Logger logger = Logger(
    printer: PrettyPrinter(),
  );

  static Logger loggerNoStack = Logger(
    printer: PrettyPrinter(methodCount: 0),
  );

  static debug(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      logger.d(message);
    }
  }

  static info(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      // logger.i(message);

      loggerNoStack.i(message);
    }
  }

  static warning(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      loggerNoStack.w(message);
    }
  }

  static error(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      logger.e(message, 'Error');
    }
  }

  static verbose(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      logger.v(message);
    }
  }

  static logWtf(dynamic message) {
    if (BuildConstants.currentEnvironment == Environment.prod) {
      // logger.wtf(message);

      loggerNoStack.wtf(message);
    }
  }
}
