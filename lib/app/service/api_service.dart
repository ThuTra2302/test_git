import 'dart:convert';

import 'package:travel/app/common/app_log.dart';

import '../common/remote/models/base_response.dart';
import '../common/remote/provider/api_client.dart';
import '../common/remote/provider/api_constant.dart';

class ApiService {
  ApiService._();

  static Future<String?> textApi() async {
    var data = jsonEncode({
      "prompt": [
        {
          "role": "user",
          "content": "Play as a travel assistant to answer the questions. If the content of the conversation is not related to travel, location, vacation, road trip, or thing to do and eat during travel, picking song based on user mood, picking karaoke song based on user mood, picking travel podcast, picking meditation music, ebook for biker, refuse to answer. Note reply in user language."
        },
        {
          "role": "assistant",
          "content": "Certainly, I'll do my best to answer questions related to travel, location, vacation, road trip, or thing to do and eat during travel, picking song based on user mood, picking karaoke song based on user mood, picking travel podcast, picking meditation music, ebook for biker. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer."
        },
        {
          "role": "user",
          "content": "This is my current location New York. Can you recommend some special local dishes or food spots that I shouldn't miss?"
        }
      ],
      "level": 3
    });

    BaseResponse baseResponse = await ApiClient.instance.request(
      endPoint: ApiConstant.conversationV2,
      method: ApiClient.post,
      data: data,
      isEncrypt: false,
    );

    if (baseResponse.result == true) {
      return baseResponse.data as String;
    } else {
      return Future.value(null);
    }
  }

  static Future<String?> sendMessenger(String data) async {
    BaseResponse baseResponse = await ApiClient.instance.request(
      endPoint: ApiConstant.conversationV2,
      method: ApiClient.post,
      data: data,
      isEncrypt: false,
    );

    AppLog.debug(baseResponse, tag: "Api service");

    if (baseResponse.result == true) {
      return baseResponse.data as String;
    } else {
      return baseResponse.message as String;
    }
  }
}
