class MessengerModel {
  final String content;
  final bool isSender;
  final bool isLimited;
  final bool isOther;

  MessengerModel({
    required this.content,
    required this.isSender,
    required this.isLimited,
    this.isOther = false,
  });
}
