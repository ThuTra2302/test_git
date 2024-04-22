import 'package:flutter/material.dart';

import '../theme/app_color.dart';

class AppLoading extends StatelessWidget {
  const AppLoading({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints.expand(),
      color: Colors.black.withOpacity(0.4),
      child: const Center(
        child: CircularProgressIndicator(
          color: AppColor.primaryColor,
        ),
      ),
    );
  }
}
