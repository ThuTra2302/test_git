typedef DateChangedCallback = Function(DateTime time);
typedef DateCancelledCallback = Function();
typedef StringAtIndexCallBack = String? Function(int index);

typedef SelectedIndexCallback = void Function(int);
typedef TimePickerCallback = void Function(DateTime);

List<int> _leapYearMonths = const <int>[1, 3, 5, 7, 8, 10, 12];

int calcDateCount(int year, int month) {
  if (_leapYearMonths.contains(month)) {
    return 31;
  } else if (month == 2) {
    if ((year % 4 == 0 && year % 100 != 0) || year % 400 == 0) {
      return 29;
    }
    return 28;
  }
  return 30;
}
