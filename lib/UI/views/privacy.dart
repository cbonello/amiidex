import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:url_launcher/url_launcher.dart';

class PrivacyView extends StatelessWidget {
  Future<String> _loadAsset(BuildContext context) async {
    // TODO(cbonello): Localized privacy.
    return DefaultAssetBundle.of(context).loadString('assets/text/privacy.md');
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        appBar: AppBar(
          title: Text(I18n.of(context).text('privacy-title')),
        ),
        body: FutureBuilder<String>(
          future: _loadAsset(context),
          builder: (BuildContext context, AsyncSnapshot<dynamic> snapshot) {
            if (!snapshot.hasData) {
              return const Center(child: CircularProgressIndicator());
            }
            return Markdown(
              data: snapshot.data,
              styleSheet:
                  MarkdownStyleSheet.fromTheme(Theme.of(context)).copyWith(
                h1: Theme.of(context)
                    .textTheme
                    .headline5
                    .copyWith(fontSize: 18.0),
              ),
              onTapLink: (String url) async {
                if (await canLaunch(url)) {
                  await launch(url);
                }
              },
            );
          },
        ),
      ),
    );
  }
}
