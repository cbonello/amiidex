import 'dart:async';

import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:webview_flutter/webview_flutter.dart';

class WebsiteView extends StatefulWidget {
  const WebsiteView({Key key, @required this.url}) : super(key: key);

  final String url;

  @override
  _WebsiteViewState createState() => _WebsiteViewState();
}

class _WebsiteViewState extends State<WebsiteView> {
  final Completer<WebViewController> _controller =
      Completer<WebViewController>();

  UniqueKey _key;
  num _stackToView;

  @override
  void initState() {
    _key = UniqueKey();
    _stackToView = 1;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final CircularProgressIndicatorThemeData progressData =
        CircularProgressIndicatorThemeData(data: themeData);

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('webview-title')),
        actions: <Widget>[
          NavigationControls(_controller.future),
        ],
      ),
      body: IndexedStack(
        index: _stackToView,
        children: <Widget>[
          WebView(
            key: _key,
            initialUrl: widget.url,
            javascriptMode: JavascriptMode.unrestricted,
            onWebViewCreated: (WebViewController webViewController) {
              _controller.complete(webViewController);
            },
            onPageFinished: (_) => setState(() => _stackToView = 0),
            debuggingEnabled: true,
          ),
          Container(
            color: Colors.white,
            child: Center(
              child: Theme(
                data: Theme.of(context).copyWith(
                  accentColor: progressData.color,
                ),
                child: const CircularProgressIndicator(),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class NavigationControls extends StatelessWidget {
  const NavigationControls(this._webViewControllerFuture)
      : assert(_webViewControllerFuture != null);

  final Future<WebViewController> _webViewControllerFuture;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<WebViewController>(
      future: _webViewControllerFuture,
      builder:
          (BuildContext context, AsyncSnapshot<WebViewController> snapshot) {
        final bool webViewReady =
            snapshot.connectionState == ConnectionState.done;
        final WebViewController controller = snapshot.data;
        return Row(
          children: <Widget>[
            IconButton(
              icon: const Icon(Icons.arrow_back_ios),
              onPressed: webViewReady
                  ? () => navigate(context, controller, goBack: true)
                  : null,
            ),
            IconButton(
              icon: const Icon(Icons.arrow_forward_ios),
              onPressed: webViewReady
                  ? () => navigate(context, controller, goBack: false)
                  : null,
            ),
          ],
        );
      },
    );
  }

  Future<void> navigate(
    BuildContext context,
    WebViewController controller, {
    bool goBack = false,
  }) async {
    final bool canNavigate =
        goBack ? await controller.canGoBack() : await controller.canGoForward();
    if (canNavigate) {
      goBack ? controller.goBack() : controller.goForward();
    } else {
      Scaffold.of(context).showSnackBar(
        SnackBar(
          content: Text(
            goBack
                ? I18n.of(context).text('webview-no-back-history')
                : I18n.of(context).text('webview-no-forward-history'),
          ),
        ),
      );
    }
  }
}
