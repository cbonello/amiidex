import 'package:amiidex/util/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/package_info.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PackageInfoService info = locator<PackageInfoService>();
    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            margin: EdgeInsets.zero,
            padding: EdgeInsets.zero,
            child:
                Image.asset('assets/images/logo_drawer.png', fit: BoxFit.fill),
          ),
          ListTile(
            leading: Icon(
              Icons.settings,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(I18n.of(context).text('drawer-settings')),
            onTap: () => Navigator.popAndPushNamed(context, '/settings'),
          ),
          ListTile(
            leading: Icon(
              Icons.perm_identity,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(I18n.of(context).text('drawer-privacy')),
            onTap: () => Navigator.popAndPushNamed(context, '/privacy'),
          ),
          ListTile(
            leading: Icon(
              Icons.code,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(I18n.of(context).text('drawer-github-source-code')),
            onTap: () async {
              Navigator.pop(context);
              _launchURL(context, 'https://github.com/cbonello/amiidex');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.bug_report,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(I18n.of(context).text('drawer-github-issue')),
            onTap: () async {
              Navigator.pop(context);
              _launchURL(context, 'https://github.com/cbonello/amiidex/issues');
            },
          ),
          ListTile(
            leading: Icon(
              Icons.info_outline,
              color: Theme.of(context).iconTheme.color,
            ),
            title: Text(I18n.of(context).text('drawer-about')),
            onTap: () async {
              Navigator.pop(context);
              showAboutDialog(
                context: context,
                applicationName: I18n.of(context).text('appname'),
                applicationVersion: info.version,
                applicationIcon: LimitedBox(
                  maxWidth: 50.0,
                  child: Image.asset('assets/images/logo_app.png'),
                ),
                applicationLegalese:
                    I18n.of(context).text('drawer-about-copyright'),
              );
            },
          ),
        ],
      ),
    );
  }

  Future<void> _launchURL(BuildContext context, String url) async {
    if (await url_launcher.canLaunch(url)) {
      await url_launcher.launch(url);
    } else {
      errorDialog(
        context,
        Text(I18n.of(context).text('error-dialog-title')),
        <Widget>[
          Text(
            sprintf(
              I18n.of(context).text('error-url-launch'),
              <String>[url],
            ),
          )
        ],
      );
    }
  }
}
