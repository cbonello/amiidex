import 'package:flutter/material.dart';
import 'package:amiidex/models/serie_list.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/actionbar_region_bottomsheet.dart';
import 'package:amiidex/util/actionbar_viewas_bottomsheet.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:provider/provider.dart';

class SerieActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final RegionProvider regionProvider = Provider.of<RegionProvider>(context);
    final SeriesSortProvider sortProvider =
        Provider.of<SeriesSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);

    final ThemeData themeData = Theme.of(context);
    final ActionBarThemeData actionBarData =
        ActionBarThemeData(data: themeData);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.all(12.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: <Widget>[
            InkWell(
              child: Row(
                children: <Widget>[
                  Text(
                    I18n.of(context).text('actionbar-sort-name'),
                    style: Theme.of(context).textTheme.body1,
                  ),
                  const SizedBox(width: 5),
                  Icon(
                    sortProvider.order == SeriesSortOrder.name_ascending
                        ? Icons.arrow_upward
                        : Icons.arrow_downward,
                    size: 15,
                    color: actionBarData.iconColor,
                  )
                ],
              ),
              onTap: () {
                sortProvider.toggleSortOrder();
              },
            ),
            InkWell(
              child: Text(I18n.of(context).text(regionProvider.regionName)),
              onTap: () {
                showRegionsBottomSheet(context, regionProvider.regionId);
              },
            ),
            InkWell(
              child: Icon(
                Icons.view_list,
                color: actionBarData.iconColor,
              ),
              onTap: () {
                showViewAsBottomSheet(context, viewAsProvider.viewAs);
              },
            ),
          ],
        ),
      ),
    );
  }
}
