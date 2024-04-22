class ApiConstant {
  ApiConstant._();

  static const Duration connectTimeout = Duration(milliseconds: 30000);
  static const Duration receiveTimeout = Duration(milliseconds: 30000);

  static const String baseUrl = "https://chat.infinityjsc.com/";

  static const String chatV2 = "${baseUrl}chatv2";
  static const String conversationV2 = "${baseUrl}conversationv2";
}
