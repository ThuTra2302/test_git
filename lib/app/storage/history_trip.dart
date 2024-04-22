class HistoryTrip {
  String? addressFrom, addressTo;

  /// 0 - false : 1 - true
  int? isFavorite;

  HistoryTrip({
    required this.addressFrom,
    required this.addressTo,
    required this.isFavorite,
  });

  HistoryTrip.fromMap(Map<String, dynamic> json) {
    addressFrom = json['addressFrom'];
    addressTo = json['addressTo'];
    isFavorite = json['isFavorite'];
  }

  Map<String, dynamic> toMap() {
    return {
      'addressFrom': addressFrom,
      'addressTo': addressTo,
      'isFavorite': isFavorite,
    };
  }
}
