import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:get/get.dart';

import '../../ads/banner_ads_widget.dart';
import '../../controller/app_controller.dart';
import '../../controller/chat_controller.dart';
import '../../data/model/messenger_model.dart';
import '../../res/image/app_image.dart';
import '../../util/app_constant.dart';
import '../theme/app_color.dart';
import '../widget/app_container.dart';
import '../widget/app_header.dart';
import '../widget/app_image_widget.dart';
import '../widget/app_touchable.dart';
import '../widget/app_touchable3.dart';
import '../widget/chat_bubble.dart';
import '../widget/chat_bubble_typing.dart';
import '../widget/expand_widget/src/expand_child.dart';
import 'sub_screen.dart';

class ChatScreen extends GetView<ChatController> {
  const ChatScreen({super.key});

  Widget buildTextField() {
    return Padding(
      padding: EdgeInsets.only(
        left: 12.0.sp,
        right: 12.0.sp,
        bottom: 12.0.sp,
      ),
      child: Obx(() => TextField(
        controller: controller.textFieldController,
        autofocus: false,
        onTap: () => controller.onTapTextField(),
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 24.0.sp,
            top: 14.0.sp,
            bottom: 14.0.sp,
          ),
          filled: true,
          enabled: !controller.isWriting.value,
          fillColor: const Color(0xFFF6F8FE),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(40.0.sp),
            borderSide: BorderSide.none,
          ),
          suffixIcon: Padding(
            padding: EdgeInsets.only(right: 12.0.sp),
            child: AppTouchable3(
              onPressed: () => controller.onPressSend(),
              child: AppImageWidget.asset(
                path: AppImage.chatSend,
              ),
            ),
          ),
          hintText: controller.listMessage.isEmpty
              ? 'Hello, can you tell me ...'
              : '',
          hintStyle: TextStyle(
            fontSize: 16.0.sp,
            color: const Color(0xFF656565),
            fontWeight: FontWeight.w500,
          ),
        ),
        onSubmitted: (value) async => controller.onPressSend(),
        minLines: 1,
        maxLines: 3,
        style: TextStyle(
          fontSize: 16.0.sp,
          color: const Color(0xFF656565),
          fontWeight: FontWeight.w500,
        ),
      )),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AppContainer(
      resizeToAvoidBottomInset: true,
      backgroundColor: const Color(0xFFE8EFF9),
      showBanner: false,
      child: Column(
        children: [
          AppHeader(
            title: "AI Assistant",
            rightWidget: Obx(() => Get.find<AppController>().isPremium.value
                ? SizedBox(
                    width: 40.0.sp,
                    height: 40.0.sp,
                  )
                : AppTouchable(
                    onPressed: () {
                      Get.to(() => const SubScreen());
                    },
                    child: AppImageWidget.asset(
                      path: AppImage.lottiePremium,
                      width: 40.0.sp,
                      height: 40.0.sp,
                    ),
                  )),
          ),
          Obx(
            () => !controller.selectedTopic.value &&
                    controller.listMessage.value.isEmpty
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 16.0.sp),
                      AppImageWidget.asset(
                        path: AppImage.botAvatar,
                        width: 40.0.sp,
                        height: 40.0.sp,
                      ),
                      SizedBox(width: 6.0.sp),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0.sp,
                            horizontal: 16.0.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(14.0.sp),
                              topLeft: Radius.circular(14.0.sp),
                              bottomLeft: Radius.circular(2.0.sp),
                              bottomRight: Radius.circular(14.0.sp),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "I will suggest you these topics",
                                style: TextStyle(
                                  color: AppColor.grayText,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.0.sp,
                                ),
                              ),
                              SizedBox(height: 8.0.sp),
                              Wrap(
                                alignment: WrapAlignment.start,
                                direction: Axis.horizontal,
                                children: AppConstant.listCategory
                                    .map((element) => CategoryItem(
                                          data: element,
                                          onPress: () {
                                            controller.onPressCategory(element);
                                          },
                                        ))
                                    .toList(),
                              ),
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0.sp),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          Obx(
            () => controller.listMessage.value.isEmpty &&
                    controller.selectedTopic.value
                ? Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      SizedBox(width: 16.0.sp),
                      AppImageWidget.asset(
                        path: AppImage.botAvatar,
                        width: 40.0.sp,
                        height: 40.0.sp,
                      ),
                      SizedBox(width: 6.0.sp),
                      Expanded(
                        child: Container(
                          padding: EdgeInsets.symmetric(
                            vertical: 12.0.sp,
                            horizontal: 16.0.sp,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            shape: BoxShape.rectangle,
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(14.0.sp),
                              topLeft: Radius.circular(14.0.sp),
                              bottomLeft: Radius.circular(2.0.sp),
                              bottomRight: Radius.circular(14.0.sp),
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "How can I help you",
                                style: TextStyle(
                                  color: AppColor.grayText,
                                  fontWeight: FontWeight.w400,
                                  fontSize: 13.0.sp,
                                ),
                              ),
                              for (int index = 0; index < 2; index++)
                                SuggestItem(
                                  text: controller
                                      .selectedCategory["list_suggest"][index],
                                  onPress: () => controller.sendWithSuggest(
                                      controller
                                              .selectedCategory["list_suggest"]
                                          [index]),
                                ),
                              ExpandChild(
                                child: Column(
                                  children: [
                                    for (int index = 2;
                                        index <
                                            controller
                                                .selectedCategory[
                                                    "list_suggest"]
                                                .length;
                                        index++)
                                      SuggestItem(
                                        text: controller.selectedCategory[
                                            "list_suggest"][index],
                                        onPress: () =>
                                            controller.sendWithSuggest(
                                                controller.selectedCategory[
                                                    "list_suggest"][index]),
                                      ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                      SizedBox(width: 16.0.sp),
                    ],
                  )
                : const SizedBox.shrink(),
          ),
          Expanded(
            child: Obx(
              () => SingleChildScrollView(
                reverse: true,
                child: ListView.builder(
                  shrinkWrap: true,
                  controller: controller.listScrollController,
                  padding: EdgeInsets.only(
                    top: 12.0.sp,
                  ),
                  itemCount: controller.listMessage.length,
                  physics: controller.isTyping.value
                      ? const NeverScrollableScrollPhysics()
                      : const BouncingScrollPhysics(),
                  itemBuilder: (BuildContext context, int index) {
                    MessengerModel messengerModel =
                        controller.listMessage[index];

                    if (index == controller.listMessage.length - 1) {
                      if (messengerModel.isSender) {
                        return Column(
                          children: [
                            Padding(
                              padding: EdgeInsets.only(
                                bottom: 12.0.sp,
                              ),
                              child: ChatBubble(
                                text: messengerModel.content,
                                isSender: messengerModel.isSender,
                                bubbleRadius: 36.0.sp,
                                isLimited: messengerModel.isLimited,
                                isOther: messengerModel.isOther,
                                onFinished: () {
                                  controller.isWriting.value = false;
                                },
                              ),
                            ),
                            Obx(
                              () => controller.isTyping.value
                                  ? ChatBubbleTyping(
                                      bubbleRadius: 30.0.sp,
                                    )
                                  : Padding(
                                      padding: EdgeInsets.only(
                                        bottom: 12.0.sp,
                                      ),
                                      child: ChatBubble(
                                        text: messengerModel.content,
                                        isSender: messengerModel.isSender,
                                        bubbleRadius: 36.0.sp,
                                        isOther: messengerModel.isOther,
                                        unlockLimit: controller.onPressUnlockLimit,
                                        isLimited: messengerModel.isLimited,
                                        onFinished: () {
                                          controller.isWriting.value = false;
                                        },
                                      ),
                                    ),
                            ),
                            SizedBox(
                              height: 12.0.sp,
                            ),
                          ],
                        );
                      } else {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: 12.0.sp,
                          ),
                          child: ChatBubble(
                            text: messengerModel.content,
                            isSender: messengerModel.isSender,
                            bubbleRadius: 36.0.sp,
                            isLimited: messengerModel.isLimited,
                            isOther: messengerModel.isOther,
                            unlockLimit: controller.onPressUnlockLimit,
                            onFinished: () {
                              controller.isWriting.value = false;
                            },
                          ),
                        );
                      }
                    } else {
                      return Padding(
                        padding: EdgeInsets.only(
                          bottom: 12.0.sp,
                        ),
                        child: ChatBubble(
                          text: messengerModel.content,
                          isSender: messengerModel.isSender,
                          bubbleRadius: 36.0.sp,
                          isLimited: messengerModel.isLimited,
                          isOther: messengerModel.isOther,
                          unlockLimit: controller.onPressUnlockLimit,
                          onFinished: () {
                            controller.isWriting.value = false;
                          },
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          ),
          // Obx(
          //   () => controller.canChat.value
          //       ? const SizedBox.shrink()
          //       : Padding(
          //           padding: EdgeInsets.only(
          //             bottom: 12.0.sp,
          //           ),
          //           child: Row(
          //             crossAxisAlignment: CrossAxisAlignment.end,
          //             mainAxisAlignment: MainAxisAlignment.start,
          //             children: [
          //               Container(
          //                 width: 60.0.sp,
          //                 height: 60.0.sp,
          //                 decoration: const BoxDecoration(
          //                   color: Colors.white,
          //                   shape: BoxShape.circle,
          //                 ),
          //                 padding: EdgeInsets.all(4.0.sp),
          //                 child: AppImageWidget.asset(
          //                   path: AppImage.animationBotAvatar,
          //                 ),
          //               ),
          //               Container(
          //                 constraints:
          //                     BoxConstraints(maxWidth: Get.width * 0.75),
          //                 child: Padding(
          //                   padding: EdgeInsets.symmetric(
          //                     horizontal: 12.0.sp,
          //                     vertical: 2.0.sp,
          //                   ),
          //                   child: Container(
          //                     decoration: BoxDecoration(
          //                       color: const Color(0xFFF3F3F3),
          //                       borderRadius: BorderRadius.only(
          //                         topLeft: Radius.circular(60.0.sp),
          //                         topRight: Radius.circular(60.0.sp),
          //                         bottomLeft: Radius.circular(2.0.sp),
          //                         bottomRight: Radius.circular(60.0.sp),
          //                       ),
          //                     ),
          //                     child: Padding(
          //                       padding: EdgeInsets.only(
          //                         top: 24.0.sp,
          //                         bottom: 24.0.sp,
          //                         left: 20.0.sp,
          //                         right: 20.0.sp,
          //                       ),
          //                       child: AnimatedTextWidget(
          //                         isRepeatingAnimation: false,
          //                         repeatForever: false,
          //                         displayFullTextOnTap: true,
          //                         totalRepeatCount: 1,
          //                         animatedTexts: [
          //                           TyperAnimatedText(
          //                             "You are out of free conversation, do you want chat more ?",
          //                             textStyle: TextStyle(
          //                               color: const Color(0xFF656565),
          //                               fontSize: 14.0.sp,
          //                               fontWeight: FontWeight.w400,
          //                             ),
          //                           ),
          //                         ],
          //                       ),
          //                     ),
          //                   ),
          //                 ),
          //               ),
          //             ],
          //           ),
          //         ),
          // ),
          buildTextField(),
          SizedBox(height: 12.0.sp),
          const BannerAdsWidget(
            isCollapsible: false,
          ),
        ],
      ),
    );
  }
}

class SuggestItem extends StatelessWidget {
  final String text;
  final Function()? onPress;

  const SuggestItem({super.key, required this.text, this.onPress});

  @override
  Widget build(BuildContext context) {
    return AppTouchable3(
      onPressed: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8EFF9),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(6.0.sp),
        ),
        padding: EdgeInsets.all(10.0.sp),
        margin: EdgeInsets.symmetric(
          vertical: 4.0.sp,
        ),
        child: Text(
          text,
          style: TextStyle(
            fontWeight: FontWeight.w400,
            fontSize: 13.0.sp,
            color: AppColor.grayText,
          ),
        ),
      ),
    );
  }
}

class CategoryItem extends StatelessWidget {
  final Map data;
  final Function()? onPress;

  const CategoryItem({super.key, required this.data, this.onPress});

  @override
  Widget build(BuildContext context) {
    return AppTouchable3(
      onPressed: onPress,
      child: Container(
        decoration: BoxDecoration(
          color: const Color(0xFFE8EFF9),
          shape: BoxShape.rectangle,
          borderRadius: BorderRadius.circular(60.0.sp),
        ),
        padding: EdgeInsets.all(8.0.sp),
        margin: EdgeInsets.symmetric(vertical: 4.0.sp, horizontal: 4.0.sp),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            SizedBox(width: 4.0.sp),
            AppImageWidget.asset(
              path: data["ic_path"],
              width: 20.0.sp,
              height: 20.0.sp,
            ),
            SizedBox(width: 8.0.sp),
            Text(
              data["title"] as String,
              style: TextStyle(
                fontWeight: FontWeight.w400,
                fontSize: 13.0.sp,
                color: AppColor.grayText,
              ),
            ),
            SizedBox(width: 4.0.sp),
          ],
        ),
      ),
    );
  }
}
