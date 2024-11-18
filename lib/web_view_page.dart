import 'dart:io' show Platform;
import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:url_launcher/url_launcher.dart';

/// author kevin
/// date 11/14/24 23:25
@RoutePage()
class WebViewPage extends StatefulWidget {
  const WebViewPage({super.key});

  @override
  State<WebViewPage> createState() => _WebViewPageState();
}

class _WebViewPageState extends State<WebViewPage> {
  final String _url = 'https://va-download.oss-cn-hangzhou.aliyuncs.com/client/app/test/test111111.mp4'; // Replace with your URL

  @override
  Widget build(BuildContext context) {
    // Check if running on mobile platform
    if (Platform.isAndroid || Platform.isIOS) {
      late final WebViewController controller;

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
        ..loadHtmlString('''
          <html>
            <body>
              <video src="$_url" controls="controls" controlslist="nofullscreen nodownload noremoteplayback" style="position: relative; right: 35px; width: 800px">
            您的浏览器不支持 video 标签。
          </video>
            </body>
          </html>
      ''');

      return Scaffold(
        appBar: AppBar(title: const Text('Flutter Simple Example')),
        body: WebViewWidget(controller: controller),
      );
    } else {
      // For desktop platforms, show a button to open in browser
      return Scaffold(
        appBar: AppBar(
          title: const Text('Open in Browser'),
          backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        ),
        body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              const Text(
                'WebView is not supported on desktop platforms.\nClick below to open in your default browser.',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 16),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () async {
                  final Uri url = Uri.parse(_url);
                  if (await canLaunchUrl(url)) {
                    await launchUrl(url);
                  } else {
                    if (context.mounted) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text('Could not launch URL'),
                        ),
                      );
                    }
                  }
                },
                child: const Text('Open in Browser'),
              ),
            ],
          ),
        ),
      );
    }
  }
}
