import 'package:flutter/material.dart';
import 'package:amiidex/UI/home/widgets/actionbar_bottomsheet_item.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';

Future<void> showRegionsBottomSheet(
    BuildContext context, String current) async {
  final RegionProvider regionProvider = Provider.of<RegionProvider>(context);

  await showModalBottomSheet<void>(
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.all(Radius.circular(12.0)),
    ),
    context: context,
    builder: (BuildContext bc) {
      return SingleChildScrollView(
        child: Wrap(
          children: <Widget>[
            ListTile(
              title: Text(I18n.of(context).text('actionbar-region-title')),
            ),
            const Divider(height: 8),
            for (String regionId in RegionIds)
              ActionBarBottomSheetItem(
                displayIcon: false,
                leading: null,
                title: I18n.of(context).text(RegionName[regionId]),
                selected: current == regionId,
                onTap: () {
                  regionProvider.regionId = regionId;
                  Navigator.pop<void>(context);
                },
              ),
          ],
        ),
      );
    },
  );
}
