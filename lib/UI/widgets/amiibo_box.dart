import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_box.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class AmiiboBoxWidget extends StatelessWidget {
  const AmiiboBoxWidget({Key key, @required this.box}) : super(key: key);

  final AmiiboBoxModel box;

  @override
  Widget build(BuildContext context) {
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(
      context,
      listen: false,
    );

    return Container(
      width: 250,
      height: 270,
      child: PageView(
        children: <Widget>[
          box.box,
          for (final AmiiboModel a in box.amiibos)
            Column(
              children: <Widget>[
                Container(height: 200, child: a.image),
                Text(
                  sprintf(
                    I18n.of(context).text('fab-scan-amiibo-name'),
                    <String>[I18n.of(context).text(a.lKey)],
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Text(
                      I18n.of(context).text('fab-scan-amiibo-status'),
                      overflow: TextOverflow.ellipsis,
                    ),
                    Text(
                      sprintf(
                        I18n.of(context).text(
                          ownedProvider.isOwned(a.lKey)
                              ? 'fab-scan-amiibo-status-owned'
                              : 'fab-scan-amiibo-status-not-owned',
                        ),
                        <String>[I18n.of(context).text(a.lKey)],
                      ),
                      style: TextStyle(
                        color: ownedProvider.isOwned(a.lKey)
                            ? OwnedColor
                            : MissingColor,
                      ),
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ],
            ),
        ],
      ),
    );
  }
}
