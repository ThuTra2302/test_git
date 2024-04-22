import 'package:flutter/foundation.dart';

import '../log_output.dart';
import '../logger.dart';

class ConsoleOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(debugPrint);
  }
}
