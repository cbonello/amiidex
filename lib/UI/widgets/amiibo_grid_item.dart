import 'package:amiidex/util/dialogs.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';
import 'package:url_launcher/url_launcher.dart' as url_launcher;

class AmiiboGridItem extends StatelessWidget {
  const AmiiboGridItem({
    Key key,
    @required this.amiibo,
    this.helpMessageDelegate,
  }) : super(key: key);

  final AmiiboModel amiibo;
  final Function helpMessageDelegate;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ItemCardThemeData itemCardData = ItemCardThemeData(data: themeData);
    final RegionProvider regionProvider = Provider.of<RegionProvider>(context);
    final LockProvider lockProvider = Provider.of<LockProvider>(context);
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);

    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: CustomMultiChildLayout(
        delegate: _LayoutDelegate(),
        children: <Widget>[
          LayoutId(
            id: 'image-background-box',
            child: Container(
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(
                  Radius.circular(6.0),
                ),
                boxShadow: <BoxShadow>[
                  BoxShadow(
                    color: itemCardData.shadowColor,
                    blurRadius: 6.0,
                    spreadRadius: 3.0,
                  ),
                ],
                color: itemCardData.backgroundColor,
              ),
            ),
          ),
          LayoutId(
            id: 'text-background-box',
            child: Container(
              color: ownedProvider.isOwned(amiibo.id)
                  ? itemCardData.missedColor
                  : itemCardData.ownedColor,
            ),
          ),
          LayoutId(
            id: 'image',
            child: GestureDetector(
              onDoubleTap: () async {
                if (await url_launcher.canLaunch(amiibo.url)) {
                  await url_launcher.launch(amiibo.url);
                } else {
                  errorDialog(
                    context,
                    Text(I18n.of(context).text('error-dialog-title')),
                    <Widget>[
                      Text(
                        sprintf(
                          I18n.of(context).text('error-url-launch'),
                          <String>[amiibo.url],
                        ),
                      )
                    ],
                  );
                }
              },
              onLongPress: () async {
                if (lockProvider.isOpened) {
                  if (helpMessageDelegate != null) {
                    Scaffold.of(context).removeCurrentSnackBar();
                    Scaffold.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          helpMessageDelegate(I18n.of(context).text(amiibo.id)),
                        ),
                      ),
                    );
                  }
                  await SystemSound.play(SystemSoundType.click);
                  ownedProvider.toggleAmiiboOwnership(amiibo.id);
                }
              },
              child: Container(
                foregroundDecoration: ownedProvider.isOwned(amiibo.id)
                    ? null
                    : BoxDecoration(
                        color: itemCardData.saturationColor,
                        backgroundBlendMode: BlendMode.saturation,
                      ),
                child: amiibo.image,
              ),
            ),
          ),
          LayoutId(
            id: 'caption',
            child: Padding(
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              child: ListView(
                shrinkWrap: true,
                children: <Widget>[
                  Text(
                    I18n.of(context).text(amiibo.id),
                    style: TextStyle(
                      color: itemCardData.color,
                      fontWeight: FontWeight.bold,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    semanticsLabel: I18n.of(context).text(amiibo.id),
                  ),
                  Text(
                    amiibo.wasReleasedInRegion(regionProvider.regionId)
                        ? DateFormat.yMMMd(
                            Localizations.localeOf(context).toString(),
                          ).format(
                            amiibo.releaseDate(regionProvider.regionId),
                          )
                        : 'N/A',
                    style: TextStyle(
                      color: itemCardData.color,
                      fontSize: 11.0,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _LayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    if (hasChild('image-background-box')) {
      layoutChild(
        'image-background-box',
        BoxConstraints.expand(width: size.width, height: size.height),
      );
      positionChild('image-background-box', const Offset(0, 0));
    }

    if (hasChild('text-background-box')) {
      final double height = size.height * 0.25;
      layoutChild(
        'text-background-box',
        BoxConstraints.tightFor(width: size.width, height: height),
      );
      positionChild('text-background-box', Offset(0, size.height - height));
    }

    if (hasChild('image')) {
      final double height = size.height * 0.75;
      layoutChild(
        'image',
        BoxConstraints.tightFor(height: height),
      );
      positionChild('image', Offset((size.height - height) / 2, 0));
    }

    if (hasChild('caption')) {
      final double height = size.height * 0.25;
      layoutChild(
        'caption',
        BoxConstraints(maxWidth: size.width, maxHeight: height),
      );
      positionChild('caption', Offset(0, size.height - height));
    }
  }

  @override
  bool shouldRelayout(_LayoutDelegate oldDelegate) => false;
}
