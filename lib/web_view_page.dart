import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';

/// author kevin
/// date 11/14/24 23:25
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  late final WebViewController controller;

  @override
  void initState() {
    super.initState();
    final videoUrl =
        'https://va-download.oss-cn-hangzhou.aliyuncs.com/client/app/test/test111111.mp4';
    controller = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setNavigationDelegate(
        NavigationDelegate(
          onProgress: (int progress) {
            // Update loading bar.
          },
          onPageStarted: (String url) {},
          onPageFinished: (String url) {},
          onHttpError: (HttpResponseError error) {},
          onWebResourceError: (WebResourceError error) {},
          onNavigationRequest: (NavigationRequest request) {
            if (request.url.startsWith('https://www.youtube.com/')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      )
      // ..loadRequest(Uri.parse(
      //     'https://va-download.oss-cn-hangzhou.aliyuncs.com/client/app/test/output22.mp4'));
      ..loadHtmlString('''
        <html>
          <body>
            <video src="${videoUrl}" controls="controls" controlslist="nofullscreen nodownload noremoteplayback" style="position: relative; right: 35px; width: 800px">
          您的浏览器不支持 video 标签。
        </video>
          </body>
        </html>
    ''');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Flutter Simple Example')),
      body: WebViewWidget(controller: controller),
    );
  }
}
