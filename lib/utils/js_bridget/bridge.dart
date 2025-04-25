import 'dart:async';
import 'package:flutter/foundation.dart'; // For debugPrint
import 'package:flutter/services.dart' show rootBundle;
import 'package:webview_flutter/webview_flutter.dart';
import 'package:uuid/uuid.dart'; // For generating event IDs
import 'payload.dart'; // Import your Payload class

/// Encapsulates communication logic between Flutter and the JS Bridge SDK.
class JSBridge {
  final WebViewController _controller;
  final String _bridgeChannelName; // JS -> Flutter requests
  final String _innerChannelName; // JS listener completion -> Flutter
  final String _jsSdkAssetPath; // Path to the bundled JS SDK file

  // StreamControllers to broadcast incoming messages
  final _jsRequestController = StreamController<Payload>.broadcast();
  final _jsListenerCompletionController = StreamController<Payload>.broadcast();

  /// Stream of requests received from the JavaScript side.
  /// Listen to this stream to handle actions initiated by JS.
  Stream<Payload> get jsRequests => _jsRequestController.stream;

  /// Stream of completion/feedback messages from JS event listeners.
  /// Listen to this stream to know when a JS listener (registered via listenMessage)
  /// has finished processing an event sent from Flutter.
  Stream<Payload> get jsListenerCompletions => _jsListenerCompletionController.stream;

  /// Creates and initializes the JS Bridge helper.
  ///
  /// IMPORTANT:
  /// 1. Call `await bridge.injectSdk()` within your WebView's `onPageFinished` callback.
  /// 2. Call `bridge.dispose()` in your widget's `dispose` method.
  ///
  /// - [controller]: The `WebViewController` instance.
  /// - [bridgeChannelName]: The name of the JavaScript channel for JS -> Flutter requests
  ///   (must match the `channelName` option in the JS SDK constructor, defaults to 'Bridge').
  /// - [innerChannelName]: The name of the JavaScript channel for JS listener completion feedback
  ///   (must match the `innerChannel` property in the JS SDK, defaults to 'native_to_client_channel').
  /// - [jsSdkAssetPath]: The path to the bundled JS SDK file in your Flutter assets
  ///   (defaults to 'assets/js/flutter-bridge-sdk.iife.js').
  JSBridge({
    required WebViewController controller,
    String bridgeChannelName = 'client_to_native_channel',
    String innerChannelName = 'native_to_client_channel',
    String jsSdkAssetPath = 'assets/js/flutter-bridge-sdk.iife.js', // Default path
  })  : _controller = controller,
        _bridgeChannelName = bridgeChannelName,
        _innerChannelName = innerChannelName,
        _jsSdkAssetPath = jsSdkAssetPath {
    _setupChannels();
  }

  /// Sets up the JavaScript channels for communication.
  void _setupChannels() {
    _controller.addJavaScriptChannel(
      _bridgeChannelName,
      onMessageReceived: (JavaScriptMessage message) {
        try {
          final payload = Payload.fromJson(message.message);
          _jsRequestController.add(payload); // Add to stream for handling
        } catch (e) {
          debugPrint('Error parsing JS request payload [$_bridgeChannelName]: $e');
          debugPrint(' -> Raw message: ${message.message}');
          // Optionally notify an error stream
        }
      },
    );

    _controller.addJavaScriptChannel(
      _innerChannelName,
      onMessageReceived: (JavaScriptMessage message) {
        try {
          final payload = Payload.fromJson(message.message);
          _jsListenerCompletionController.add(payload); // Add to stream
        } catch (e) {
          debugPrint('Error parsing JS listener completion payload [$_innerChannelName]: $e');
          debugPrint(' -> Raw message: ${message.message}');
          // Optionally notify an error stream
        }
      },
    );
     debugPrint('JSBridge: Channels "$_bridgeChannelName" and "$_innerChannelName" configured.');
  }

  /// Loads and injects the JS Bridge SDK script into the WebView.
  /// Injects the SDK from native, it is not need to call this method in most cases.
  /// **Call this method from your WebView's `onPageFinished` callback.**
  Future<void> injectSdk() async {
    try {
      final sdkScript = await rootBundle.loadString(_jsSdkAssetPath);
      await _controller.runJavaScript(sdkScript);
      debugPrint('JSBridge: SDK injected successfully from $_jsSdkAssetPath.');
    } catch (e) {
      debugPrint('JSBridge: Error loading or injecting SDK from $_jsSdkAssetPath: $e');
      // Consider throwing or notifying an error stream
    }
  }

  // --- Private Helper for Sending Messages ---

  /// Sends a payload to the JS Bridge's dispatch method.
  /// Handles JSON conversion and escaping.
  Future<void> _sendMessageToJs(Payload payload) async {
    final jsonPayload = payload.toJson();
    final escapedJsonPayload = jsonPayload
        .replaceAll('\\', '\\\\')
        .replaceAll("'", "\\'")
        .replaceAll('"', '\\"') // Safer to escape double quotes too
        .replaceAll('\n', '\\n')
        .replaceAll('\r', '\\r');

    // Ensure the FlutterBridge instance and dispatch method exist before calling
    final script = """
      if (window.flutterBridge && typeof window.flutterBridge.dispatch === 'function') {
        window.flutterBridge.dispatch('$escapedJsonPayload');
      } else {
        console.error('FlutterBridge SDK or dispatch method not found when trying to send message: ${payload.action}/${payload.id}');
      }
    """;
    debugPrint("JSBridge: Sending to JS -> $script");
    try {
      // Note: No internal readiness check here; caller must ensure WebView is ready.
      await _controller.runJavaScript(script);
    } catch (e) {
      debugPrint("!!! JSBridge: Error running JavaScript to dispatch message: $e");
       debugPrint("   -> Failed Payload: $jsonPayload");
    }
  }

  // --- Public Methods for Sending Messages ---

  /// Sends a response back to a specific JavaScript request.
  /// - [originalId]: The ID received from the original JS request payload.
  /// - [data]: The data to send back as the successful result.
  Future<void> sendResponse(String originalId, dynamic data) {
    final responsePayload = Payload(
      id: originalId,
      code: 200,
      data: data,
    );
    return _sendMessageToJs(responsePayload);
  }

  /// Sends an error response back to a specific JavaScript request.
  /// - [originalId]: The ID received from the original JS request payload.
  /// - [errorMessage]: A description of the error.
  /// - [code]: An error code (e.g., 404, 500).
  Future<void> sendError(String originalId, String errorMessage, int code) {
    final errorPayload = Payload(
      id: originalId,
      code: code,
      errorMessage: errorMessage,
    );
    return _sendMessageToJs(errorPayload);
  }

  /// Sends an event initiated by Flutter to JavaScript listeners.
  /// - [action]: The event name that JS listeners (via `listenMessage`) will subscribe to.
  /// - [data]: The data payload for the event.
  Future<void> sendEvent(String action, dynamic data) {
    final eventPayload = Payload(
      action: action,
      // JS needs the ID to send completion feedback via innerChannel
      id: const Uuid().v4(),
      data: data,
    );
    return _sendMessageToJs(eventPayload);
  }

  /// Cleans up resources, primarily closing the StreamControllers.
  /// Call this in your widget's dispose method.
  void dispose() {
    _jsRequestController.close();
    _jsListenerCompletionController.close();
     debugPrint('JSBridge: Disposed.');
  }
}