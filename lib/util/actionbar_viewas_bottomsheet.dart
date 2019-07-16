import 'package:flutter/material.dart';
import 'package:amiidex/UI/home/widgets/actionbar_bottomsheet_item.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';

Future<void> showViewAsBottomSheet(
    BuildContext context, DisplayType current) async {
  final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);

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
              title: Text(I18n.of(context).text('actionbar-viewas-title')),
            ),
            const Divider(height: 8),
            ActionBarBottomSheetItem(
              displayIcon: true,
              leading: Icons.view_list,
              title: I18n.of(context).text('actionbar-viewas-list'),
              selected: current == DisplayType.list,
              onTap: () {
                viewAsProvider.viewAs = DisplayType.list;
                Navigator.pop<void>(context);
              },
            ),
            ActionBarBottomSheetItem(
              displayIcon: true,
              leading: Icons.view_comfy,
              title: I18n.of(context).text('actionbar-viewas-grid-small-icons'),
              selected: current == DisplayType.grid_small,
              onTap: () {
                viewAsProvider.viewAs = DisplayType.grid_small;
                Navigator.pop<void>(context);
              },
            ),
            ActionBarBottomSheetItem(
              displayIcon: true,
              leading: Icons.view_module,
              title: I18n.of(context).text('actionbar-viewas-grid-large-icons'),
              selected: current == DisplayType.grid_large,
              onTap: () {
                viewAsProvider.viewAs = DisplayType.grid_large;
                Navigator.pop<void>(context);
              },
            ),
          ],
        ),
      );
    },
  );
}
