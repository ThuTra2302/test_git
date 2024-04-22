import 'package:travel/app/controller/app_controller.dart';

extension IntTemp on int {
  int toC() {
    return this;
  }

  int toF() {
    return (this * 1.8 + 32).round();
  }

  int toK() {
    return this + 273;
  }

  int toUnit(UnitTypeTemp unitTypeTemp) {
    switch (unitTypeTemp) {
      case UnitTypeTemp.c:
        return this;
      case UnitTypeTemp.f:
        return (this * 1.8 + 32).round();
      case UnitTypeTemp.k:
        return this + 273;
    }
  }
}
