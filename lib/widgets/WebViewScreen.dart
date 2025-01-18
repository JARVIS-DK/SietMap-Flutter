import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_inappwebview/flutter_inappwebview.dart';
import 'package:google_fonts/google_fonts.dart';

import 'GradientText.dart';

class WebViewScreen extends StatefulWidget {
  const WebViewScreen({super.key});

  @override
  State<WebViewScreen> createState() => _WebViewScreenState();
}

class _WebViewScreenState extends State<WebViewScreen> {
  late InAppWebViewController inAppWebViewController;
  bool _isErrorPage = false;

  final String? webviewURL = dotenv.env['WEBVIEW_URL'] ?? 'https://siet.ac.in/';

  Future<void> _reloadPage() async {
    setState(() {
      _isErrorPage = false; // Reset error state when reloading
    });
    await inAppWebViewController.reload();
  }

  bool _isLoading = true; // Track loading state

  @override
  void initState() {
    super.initState();
    // Show the CircularProgressIndicator for 5 seconds
    Future.delayed(const Duration(seconds: 5), () {
      setState(() {
        _isLoading = false; // Hide the loading indicator after 5 seconds
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: GradientText(
            "SIET Map",
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
          leading: Padding(
            padding: const EdgeInsets.only(
              left: 10.0,
              top: 8.0,
              bottom: 8.0,
            ),
            child: Image.asset(
              'assets/siet_icon.png',
              fit: BoxFit.contain,
            ),
          ),
          actions: [
            Padding(
              padding: EdgeInsets.only(right: 10),
              child: FloatingActionButton.small(
                onPressed: _reloadPage,
                child: const Icon(
                  Icons.refresh,
                  color: Colors.white,
                ),
                backgroundColor: Colors.blue,
              ),
            ),
          ],
          backgroundColor: const Color(0xFFF1EFEC),
        ),
        body: Stack(
          children: [
            if (!_isErrorPage)
              RefreshIndicator(
                onRefresh: _reloadPage,
                child: InAppWebView(
                  initialUrlRequest: URLRequest(
                    url: WebUri(webviewURL!),
                  ),
                  initialSettings: InAppWebViewSettings(
                    contentBlockers: [
                      ContentBlocker(
                        trigger: ContentBlockerTrigger(urlFilter: ".*"),
                        action: ContentBlockerAction(
                          type: ContentBlockerActionType.CSS_DISPLAY_NONE,
                          selector:
                              '#share-button, .mappedin-ctrl-bottom-right, #marker-banner, #accessible-directions-toggle, #mappedin-viewer-fullscreen-overlay',
                        ),
                      )
                    ],
                  ),
                  onWebViewCreated: (InAppWebViewController controller) {
                    inAppWebViewController = controller;
                  },
                  shouldOverrideUrlLoading:
                      (controller, navigationAction) async {
                    final uri = navigationAction.request.url;

                    if (uri != null && uri.toString() != webviewURL) {
                      // Prevent redirection by canceling the navigation
                      return NavigationActionPolicy.CANCEL;
                    }
                    return NavigationActionPolicy.ALLOW;
                  },
                  onLoadError: (controller, url, code, message) {
                    // Detect when the page load fails with an internet error
                    if (message.contains("ERR_INTERNET_DISCONNECTED") ||
                        message.contains("ERR_NAME_NOT_RESOLVED")) {
                      setState(() {
                        _isErrorPage = true;
                      });
                    }
                  },
                ),
              )
            else
              Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.wifi_off, size: 50, color: Colors.red),
                    const SizedBox(height: 10),
                    const Text(
                      "No Internet Connection",
                      style: TextStyle(fontSize: 18),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      onPressed: _reloadPage,
                      icon: const Icon(
                        Icons.refresh,
                        color: Colors.white,
                      ),
                      label: const Text(
                        "Retry",
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue, // Customize button color
                        padding: const EdgeInsets.symmetric(
                            horizontal: 20, vertical: 10),
                        textStyle: const TextStyle(fontSize: 16),
                      ),
                    ),
                  ],
                ),
              ),
            if (_isLoading)
              const Center(
                child: SizedBox(
                  width: 52,
                  height: 52,
                  child: CircularProgressIndicator(
                    color: Colors.blue,
                    strokeWidth: 4.0,
                  ),
                ),
              ),
            const Positioned(
              bottom: 2.0,
              left: 12.0,
              child: Text(
                '© Dhanush Kumar | CSE | 2022 - 2026',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
