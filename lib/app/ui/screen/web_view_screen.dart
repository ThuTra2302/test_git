import 'package:flutter/material.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';

import '../widget/app_container.dart';
import '../widget/app_header.dart';

class WebViewScreen extends StatefulWidget {
  final String url;

  const WebViewScreen({
    Key? key,
    required this.url,
  }) : super(key: key);

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  @override
  Widget build(BuildContext context) {
    return AppContainer(
      child: Column(
        children: [
          const AppHeader(),
          Expanded(
            child: InAppWebView(
              initialUrlRequest: URLRequest(
                url: Uri.parse(widget.url),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
