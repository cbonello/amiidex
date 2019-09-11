import 'dart:collection';

import 'package:amiidex/UI/views/amiibos_by_serie.dart';
import 'package:amiidex/models/serie.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SerieListItem extends StatelessWidget {
  const SerieListItem({
    Key key,
    @required this.series,
    @required this.serie,
  }) : super(key: key);

  final UnmodifiableListView<SerieModel> series;
  final SerieModel serie;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () async {
        await SystemSound.play(SystemSoundType.click);
        Navigator.push(
          context,
          MaterialPageRoute<void>(
            maintainState: true,
            builder: (BuildContext context) => AmiibosBySerieView(
              series: series,
              serie: serie,
            ),
          ),
        );
      },
      child: Padding(
        padding: const EdgeInsets.all(5.0),
        child: Row(
          mainAxisSize: MainAxisSize.max,
          children: <Widget>[
            Expanded(
              child: Container(
                height: 100,
                child: _Item(serie: serie),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Item extends StatelessWidget {
  const _Item({
    Key key,
    @required this.serie,
  }) : super(key: key);

  final SerieModel serie;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final ItemCardThemeData itemCardData = ItemCardThemeData(data: themeData);
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);

    return CustomMultiChildLayout(
      delegate: _LayoutDelegate(),
      children: <Widget>[
        LayoutId(
          id: 'image-background-box',
          child: Container(
            decoration: BoxDecoration(
              // borderRadius: const BorderRadius.all(
              //   Radius.circular(6.0),
              // ),
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
            decoration: BoxDecoration(
              // borderRadius: const BorderRadius.only(
              //   topRight: Radius.circular(6.0),
              //   bottomRight: Radius.circular(6.0),
              // ),
              color: (ownedProvider.ownedInSerie(serie) == serie.amiibos.length)
                  ? itemCardData.missedColor
                  : itemCardData.ownedColor,
            ),
          ),
        ),
        LayoutId(
          id: 'image',
          child: Center(
            child: serie.logo,
          ),
        ),
        LayoutId(
          id: 'caption',
          child: Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Text(
                  I18n.of(context).text(serie.lKey),
                  style: TextStyle(
                    color: itemCardData.color,
                    fontWeight: FontWeight.bold,
                  ),
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  '${ownedProvider.ownedInSerie(serie)} / ${serie.amiibos.length}',
                  style: TextStyle(
                    color: itemCardData.color,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _LayoutDelegate extends MultiChildLayoutDelegate {
  @override
  void performLayout(Size size) {
    final double imageHeight = size.height * 0.9;
    final double textBackgroundWidth = size.width * 2.0 / 3.0;
    final double imageWidth = (size.width - textBackgroundWidth) * 0.9;

    if (hasChild('image-background-box')) {
      layoutChild(
        'image-background-box',
        BoxConstraints.expand(width: size.width, height: size.height),
      );
      positionChild('image-background-box', const Offset(0, 0));
    }

    if (hasChild('text-background-box')) {
      layoutChild(
        'text-background-box',
        BoxConstraints.expand(width: textBackgroundWidth, height: size.height),
      );
      positionChild(
          'text-background-box', Offset(size.width - textBackgroundWidth, 0));
    }

    if (hasChild('image')) {
      final Size img = layoutChild(
        'image',
        BoxConstraints.loose(Size(imageWidth, imageHeight)),
      );
      positionChild(
          'image',
          Offset(((size.width - textBackgroundWidth) - img.width) / 2,
              (size.height - img.height) / 2.0));
    }

    if (hasChild('caption')) {
      final double height = size.height * 0.9;
      layoutChild(
        'caption',
        BoxConstraints(maxWidth: textBackgroundWidth, maxHeight: height),
      );
      positionChild(
          'caption',
          Offset(
              size.width - textBackgroundWidth, (size.height - height) / 2.0));
    }
  }

  @override
  bool shouldRelayout(_LayoutDelegate oldDelegate) => false;
}
