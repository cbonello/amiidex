import 'package:flutter/material.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/package_info.dart';
import 'package:amiidex/util/i18n.dart';

class DrawerWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final PackageInfoService info = locator<PackageInfoService>();
    return Drawer(
      child: Column(
        children: <Widget>[
          Container(
            color: Colors.white, //.grey[600],
            height: 215.0,
            child: Stack(
              children: <Widget>[
                Image.asset('assets/images/logo_drawer.png'),
                const Positioned.fill(
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: Text(
                      'amiidex',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 64.0,
                        fontFamily: 'bauhaus',
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          const Divider(height: 10, color: Colors.black),
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
}
