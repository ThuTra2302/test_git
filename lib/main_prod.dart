import 'main.dart';
import 'build_constants.dart';

void main() {
  BuildConstants.setEnvironment(Environment.prod);
  mainDelegate();
}
