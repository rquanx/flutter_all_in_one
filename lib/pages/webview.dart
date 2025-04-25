import 'dart:async';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_application_1/utils/js_bridget/bridge.dart';
import 'package:flutter_application_1/utils/js_bridget/payload.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebViewComponent extends StatefulWidget {
  const WebViewComponent({super.key, required this.url});
  final String url;

  @override
  State<WebViewComponent> createState() => _WebViewComponentState();
}

class _WebViewComponentState extends State<WebViewComponent> {
  late final WebViewController controller;
  JSBridge? jsBridge; // Hold the bridge instance
  StreamSubscription? jsRequestSubscription;
  StreamSubscription? jsCompletionSubscription;

  @override
  void initState() {
    super.initState();

    // #docregion webview_controller
    controller =
        WebViewController()
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
          ..loadRequest(Uri.parse(widget.url));
    // #enddocregion webview_controller

    // --- Initialize JSBridge AFTER controller is created ---
    jsBridge = JSBridge(controller: controller);

    // --- Listen to Streams from the bridge ---
    jsRequestSubscription = jsBridge?.jsRequests.listen(_handleJsRequest);
    jsCompletionSubscription = jsBridge?.jsListenerCompletions.listen(
      _handleJsCompletion,
    );
  }

  // --- Handle incoming JS requests ---
  void _handleJsRequest(Payload payload) {
    debugPrint(
      'Received JS Request: action=${payload.action}, id=${payload.id}, data=${payload.data}',
    );
    if (payload.action == 'clientToNative') {
      jsBridge?.sendResponse(payload.id, {"count": Random().nextInt(1000)});
    }
    // IMPORTANT: Check if page is finished before processing if needed
    // if (!_isPageFinished) return;

    // Your logic to handle the request based on payload.action
    // switch (payload.action) {
    //   case 'getUserData':
    //     // Simulate fetching data and responding
    //     Future.delayed(const Duration(milliseconds: 300), () {
    //       jsBridge?.sendResponse(payload.id, {
    //         'name': 'Dart User',
    //         'status': 'online',
    //       });
    //     });
    //     break;
    //   case 'showNativeToast':
    //     final message = payload.data?['message'] ?? 'Default toast message';
    //     ScaffoldMessenger.of(
    //       context,
    //     ).showSnackBar(SnackBar(content: Text(message)));
    //     // Acknowledge back to JS
    //     jsBridge?.sendResponse(payload.id, {'toastDisplayed': true});
    //     break;
    //   // ... other actions
    //   default:
    //     jsBridge?.sendError(
    //       payload.id,
    //       'Unknown action: ${payload.action}',
    //       404,
    //     );
    // }
  }

  // --- Handle incoming JS listener completions ---
  void _handleJsCompletion(Payload payload) {
    debugPrint(
      'Received JS Completion: action=${payload.action}, id=${payload.id}, code=${payload.code}, data=${payload.data}',
    );
    if (payload.code == 200) {
      // JS listener finished successfully
    } else {
      // JS listener encountered an error
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Container(
            constraints: BoxConstraints(maxHeight: 700),
            child: WebViewWidget(controller: controller),
          ),
          ElevatedButton(
            onPressed:
                () => {
                  jsBridge?.sendEvent('nativeToClient', {
                    "count": Random().nextDouble() * Random().nextInt(100),
                  }),
                },
            child: const Text('native to client'),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up subscriptions and the bridge itself
    jsRequestSubscription?.cancel();
    jsCompletionSubscription?.cancel();
    jsBridge?.dispose();
    super.dispose();
  }
}
