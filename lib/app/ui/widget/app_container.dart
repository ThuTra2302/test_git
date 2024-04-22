import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../ads/banner_ads_widget.dart';
import '../theme/app_color.dart';

class AppContainer extends StatelessWidget {
  const AppContainer({
    Key? key,
    this.appBar,
    this.onWillPop,
    this.bottomNavigationBar,
    this.child,
    this.backgroundColor,
    this.coverScreenWidget,
    this.resizeToAvoidBottomInset = false,
    this.floatingActionButton,
    this.showBanner = true,
    this.isCollapsibleBanner = true,
  }) : super(key: key);

  final PreferredSizeWidget? appBar;
  final Future<bool> Function()? onWillPop;
  final Widget? bottomNavigationBar;
  final Widget? child;
  final Color? backgroundColor;
  final Widget? coverScreenWidget;
  final bool? resizeToAvoidBottomInset;
  final Widget? floatingActionButton;
  final bool showBanner;
  final bool isCollapsibleBanner;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: onWillPop ??
          () async {
            return false;
          },
      child: Stack(
        children: [
          GestureDetector(
            onTap: () {
              FocusScopeNode currentFocus = FocusScope.of(context);
              if (!currentFocus.hasPrimaryFocus) {
                currentFocus.unfocus();
              }
            },
            child: Scaffold(
              resizeToAvoidBottomInset: resizeToAvoidBottomInset,
              backgroundColor: backgroundColor ?? AppColor.whiteBG,
              appBar: appBar,
              body: SizedBox(
                width: Get.width,
                height: Get.height,
                child: child ?? const SizedBox.shrink(),
              ),
              floatingActionButton: floatingActionButton,
              bottomNavigationBar: bottomNavigationBar,
            ),
          ),
          coverScreenWidget ?? const SizedBox.shrink(),
          showBanner
              ? const Align(
                  alignment: Alignment.bottomCenter,
                  child: BannerAdsWidget(),
                )
              : const SizedBox.shrink()
        ],
      ),
    );
  }
}
