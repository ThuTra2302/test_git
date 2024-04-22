import 'dart:convert';

import 'package:firebase_analytics/firebase_analytics.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../ads/reward_ads_manager.dart';
import '../common/app_log.dart';
import '../data/model/messenger_model.dart';
import '../service/api_service.dart';
import '../ui/theme/app_color.dart';
import '../util/network_time/ntp.dart';
import 'app_controller.dart';
import 'main_controller.dart';

class ChatController extends GetxController {
  static const int minCountMessengerSendApi = 6;
  static const int limitMessenger = 5;

  final AppController appController = Get.find<AppController>();

  String messenger1 =
      "Play as a tour guide to answer the questions. If the content of the conversation is not related to travel, location, vacation, road trip, or thing to do and eat during travel, refuse to answer. Note reply in user language.";
  String messenger2 =
      "Certainly, I'll do my best to answer questions related to travel, location, vacation, road trip, or thing to do and eat during travel. Please feel free to ask any questions you have in those domains, and I'll provide you with accurate information. If a question is unrelated to these topics, I'll let you know that I cannot provide an answer.";
  String messenger3 =
      "This is my current location ${Get.find<MainController>().dataLocation}.";

  String strPremium =
      "Your 3 free questions today have been exhausted. Should you wish to explore further, I offer you the Premium package which will give you unlimited questions with a more comprehensive reading or you can come back tomorrow for more";

  String strWatchAds = "Watch ads to view an answer.";

  TextEditingController textFieldController = TextEditingController();
  ScrollController listScrollController = ScrollController();

  RxList listMessage = <MessengerModel>[].obs;
  RxBool isTyping = false.obs;
  RxBool isLimited = false.obs;
  RxBool isWriting = false.obs;

  RxMap selectedCategory = {}.obs;
  RxBool selectedTopic = false.obs;

  late final SharedPreferences prefs;

  @override
  void onReady() {
    super.onReady();

    Future.delayed(
      Duration.zero,
      () async {
        prefs = await SharedPreferences.getInstance();
        if (appController.isPremium.value) {
          await doInit();
        }
      },
    );
  }

  Future<void> doInit() async {
    var dateTimeReceiveStr = prefs.getString("send_time");

    DateTime dateTimeSend = await NTP.now();
    DateTime dateTimeReceive = DateTime.parse(
      dateTimeReceiveStr ?? dateTimeSend.toUtc().toIso8601String(),
    );

    if (dateTimeReceive.isAfter(dateTimeSend)) {
      isLimited.value = false;
    } else {
      var iCntSend = prefs.getInt('cnt_send') ?? 0;

      if (iCntSend >= limitMessenger) {
        isLimited.value = true;
      } else {
        isLimited.value = false;
      }
    }
  }

  void onTapTextField() {}

  void onPressSend() async {
    if (isTyping.value) {
      Get.snackbar(
        "Error",
        "You cant send multiple messages at a time",
        backgroundColor: AppColor.red600,
        colorText: Colors.white,
      );

      return;
    }

    if (textFieldController.text.isEmpty) {
      Get.snackbar(
        "Error",
        "Please type a message",
        backgroundColor: AppColor.red600,
        colorText: Colors.white,
      );

      return;
    }

    String message = textFieldController.text;

    int cntSendChat = prefs.getInt("cnt_send_chat") ?? 1;

    if (!appController.isPremium.value) {
      if (cntSendChat == 4) {
        bool check = false;

        for (MessengerModel element in listMessage.value) {
          if (element.content == strWatchAds) {
            check = true;
          }
        }

        if (!check) {
          listMessage.add(
            MessengerModel(
              content: strWatchAds,
              isSender: false,
              isLimited: false,
              isOther: true,
            ),
          );
        }

        return;
      }

      if (isLimited.value || cntSendChat >= limitMessenger) {
        bool check = false;

        for (MessengerModel element in listMessage.value) {
          if (element.content == strPremium) {
            check = true;
          }
        }

        if (!check) {
          listMessage.add(MessengerModel(
            content: strPremium,
            isSender: false,
            isLimited: true,
          ));
        }

        return;
      }
    }

    listMessage.add(MessengerModel(
      content: message,
      isSender: true,
      isLimited: false,
    ));
    textFieldController.text = "";

    if(listMessage.length <= 5) {
      FirebaseAnalytics.instance.logEvent(name: 'AI_question_${listMessage.length}');
    }

    List listMessageSendApi = <MessengerModel>[];

    try {
      isTyping.value = true;

      if (selectedTopic.value) {
        if (listMessage.length < minCountMessengerSendApi) {
          listMessageSendApi.add(MessengerModel(
            content: messenger1,
            isSender: true,
            isLimited: false,
          ));

          listMessageSendApi.add(MessengerModel(
            content: messenger2,
            isSender: false,
            isLimited: false,
          ));

          listMessageSendApi.addAll(listMessage.sublist(1));
        } else {
          listMessageSendApi = listMessage
              .sublist(listMessage.length - minCountMessengerSendApi + 1);
        }
      } else {
        if (listMessage.length < minCountMessengerSendApi) {
          listMessageSendApi.addAll(listMessage);
        } else {
          listMessageSendApi = listMessage
              .sublist(listMessage.length - minCountMessengerSendApi);
        }
      }

      List<Map<String, String>> listPrompt = [];
      for (int i = 0; i < listMessageSendApi.length; i++) {
        MessengerModel messengerModel = listMessageSendApi[i];

        listPrompt.add({
          "role": messengerModel.isSender ? "user" : "assistant",
          "content": messengerModel.content,
        });
      }

      AppLog.debug(listPrompt);

      String data = jsonEncode({"prompt": listPrompt, "level": 3});

      String? answer = await ApiService.sendMessenger(data);

      listMessage.add(MessengerModel(
        content: answer ?? "",
        isSender: false,
        isLimited: false,
      ));

      prefs.setInt("cnt_send_chat", ++cntSendChat);

      textFieldController.text = "";

      isTyping.value = false;
    } catch (error) {
      debugPrint("Error send message: ${error.toString()}");

      Get.snackbar(
        "Error",
        error.toString(),
        backgroundColor: AppColor.red600,
      );

      isTyping.value = false;
      isWriting.value = true;
    } finally {
      isTyping.value = false;
    }
  }

  void sendWithSuggest(String text) async {
    int cntSendChat = prefs.getInt("cnt_send_chat") ?? 1;

    if (!appController.isPremium.value) {
      if (cntSendChat >= limitMessenger) {
        bool check = false;

        for (MessengerModel element in listMessage.value) {
          AppLog.debug(element.content);

          if (element.content == strPremium) {
            check = true;
          }
        }

        if (!check) {
          listMessage.add(MessengerModel(
            content: strPremium,
            isSender: false,
            isLimited: true,
          ));
        }

        return;
      }
    }

    if (isTyping.value) {
      Get.snackbar(
        "Error",
        "You cant send multiple messages at a time",
        backgroundColor: AppColor.red600,
        colorText: Colors.white,
      );

      return;
    }

    listMessage.add(MessengerModel(
      content: text,
      isSender: true,
      isLimited: false,
    ));

    List listMessageSendApi = <MessengerModel>[];

    try {
      isTyping.value = true;

      listMessageSendApi.add(MessengerModel(
        content: messenger1,
        isSender: true,
        isLimited: false,
      ));

      listMessageSendApi.add(MessengerModel(
        content: messenger2,
        isSender: false,
        isLimited: false,
      ));

      listMessageSendApi.add(MessengerModel(
        content: "$messenger3 $text",
        isSender: true,
        isLimited: false,
      ));

      List<Map<String, String>> listPrompt = [];
      for (int i = 0; i < listMessageSendApi.length; i++) {
        MessengerModel messengerModel = listMessageSendApi[i];

        listPrompt.add({
          "role": messengerModel.isSender ? "user" : "assistant",
          "content": messengerModel.content,
        });
      }

      AppLog.debug(listPrompt);

      String data = jsonEncode({"prompt": listPrompt, "level": 3});

      String? answer = await ApiService.sendMessenger(data);

      listMessage.add(MessengerModel(
        content: answer ?? "",
        isSender: false,
        isLimited: false,
      ));

      prefs.setInt("cnt_send_chat", ++cntSendChat);

      textFieldController.text = "";

      isTyping.value = false;
    } catch (error) {
      debugPrint("Error send message: ${error.toString()}");

      Get.snackbar(
        "Error",
        error.toString(),
        backgroundColor: AppColor.red600,
      );

      isTyping.value = false;
      isWriting.value = true;
    } finally {
      isTyping.value = false;
    }
  }

  void onPressCategory(Map data) {
    FirebaseAnalytics.instance.logEvent(name: 'AI_Click_${data["title"]}');

    selectedCategory.value = data;
    selectedTopic.value = true;

    messenger1 = data["messenger1"];
    messenger2 = data["messenger2"];
  }

  void onPressUnlockLimit() {
    FirebaseAnalytics.instance.logEvent(name: 'AI_Reward4');
    showRewardAds(_onPressUnlockLilit);
  }

  void _onPressUnlockLilit() async {
    listMessage.removeLast();

    List listMessageSendApi = <MessengerModel>[];

    String message = textFieldController.text;
    listMessage.add(MessengerModel(
      content: message,
      isSender: true,
      isLimited: false,
    ));

    try {
      isTyping.value = true;

      if (listMessage.length < minCountMessengerSendApi) {
        listMessageSendApi.add(MessengerModel(
          content: messenger1,
          isSender: true,
          isLimited: false,
        ));

        listMessageSendApi.add(MessengerModel(
          content: messenger2,
          isSender: false,
          isLimited: false,
        ));

        listMessageSendApi.addAll(listMessage.sublist(1));
      } else {
        listMessageSendApi = listMessage
            .sublist(listMessage.length - minCountMessengerSendApi + 1);
      }

      List<Map<String, String>> listPrompt = [];
      for (int i = 0; i < listMessageSendApi.length; i++) {
        MessengerModel messengerModel = listMessageSendApi[i];

        listPrompt.add({
          "role": messengerModel.isSender ? "user" : "assistant",
          "content": messengerModel.content,
        });
      }

      AppLog.debug(listPrompt);

      String data = jsonEncode({"prompt": listPrompt, "level": 3});

      String? answer = await ApiService.sendMessenger(data);

      listMessage.add(MessengerModel(
        content: answer ?? "",
        isSender: false,
        isLimited: false,
      ));
      prefs.setInt("cnt_send_chat", 5);

      textFieldController.text = "";

      isTyping.value = false;
    } catch (error) {
      debugPrint("Error send message: ${error.toString()}");

      Get.snackbar(
        "Error",
        error.toString(),
        backgroundColor: AppColor.red600,
      );

      isTyping.value = false;
      isWriting.value = true;
    } finally {
      isTyping.value = false;
    }
  }
}
