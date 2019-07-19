import 'package:dynamic_theme/dynamic_theme.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/preferred_language.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';

class SettingsView extends StatefulWidget {
  const SettingsView({Key key, this.title = 'Settings'}) : super(key: key);

  final String title;

  @override
  SettingsViewState createState() => SettingsViewState();
}

class SettingsViewState extends State<SettingsView> {
  Brightness _brightness;

  @override
  void initState() {
    _brightness = DynamicTheme.of(context).brightness;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final PreferredLanguageProvider languageProvider =
        Provider.of<PreferredLanguageProvider>(context);
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: ListView(
        children: <Widget>[
          ListTile(title: Text(I18n.of(context).text('settings-general'))),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text(I18n.of(context).text('settings-language'))),
                Expanded(
                  flex: 2,
                  child: DropdownButton<Locale>(
                    value: languageProvider.locale,
                    onChanged: (Locale newLang) {
                      languageProvider.language = newLang.toString();
                    },
                    items: <DropdownMenuItem<Locale>>[
                      for (Locale l in I18n.delegate.supportedLocales)
                        DropdownMenuItem<Locale>(
                          value: l,
                          child: Text(
                            I18n.of(context).text(l.toString()),
                          ),
                        )
                    ],
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Expanded(
                    child: Text(I18n.of(context).text('settings-collection'))),
                Expanded(
                  flex: 2,
                  child: RaisedButton(
                    onPressed: ownedProvider.ownedCount > 0
                        ? () async {
                            final bool reset = await _resetDialog(context);
                            if (reset) {
                              ownedProvider.reset();
                            }
                          }
                        : null,
                    textColor: Colors.white,
                    child: Text(
                      I18n.of(context).text('settings-collection-reset'),
                    ),
                  ),
                ),
              ],
            ),
          ),
          ListTile(title: Text(I18n.of(context).text('settings-theme'))),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18n.of(context).text('settings-light-theme')),
                Radio<Brightness>(
                  value: Brightness.light,
                  groupValue: _brightness,
                  onChanged: (Brightness newBrightness) {
                    setState(() {
                      _brightness = newBrightness;
                    });
                    DynamicTheme.of(context).setBrightness(newBrightness);
                  },
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 40.0, right: 20.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                Text(I18n.of(context).text('settings-dark-theme')),
                Radio<Brightness>(
                  value: Brightness.dark,
                  groupValue: _brightness,
                  onChanged: (Brightness newBrightness) {
                    setState(() {
                      _brightness = newBrightness;
                    });
                    DynamicTheme.of(context).setBrightness(newBrightness);
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<bool> _resetDialog(BuildContext context) async {
    return await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(I18n.of(context).text('settings-collection-reset')),
          content: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Text(
              I18n.of(context).text('settings-collection-reset-question'),
            ),
          ),
          actions: <Widget>[
            RaisedButton(
              textColor: Colors.white,
              child: Text(I18n.of(context)
                  .text('settings-collection-reset-cancel-button')),
              onPressed: () {
                Navigator.of(context).pop(false);
              },
            ),
            RaisedButton(
              textColor: Colors.white,
              child: Text(I18n.of(context)
                  .text('settings-collection-reset-reset-button')),
              onPressed: () {
                Navigator.of(context).pop(true);
              },
            ),
          ],
        );
      },
    );
  }
}
