import 'package:flutter/material.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/actionbar_viewas_bottomsheet.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:provider/provider.dart';

class SerieActionBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final SeriesSortProvider sortProvider =
        Provider.of<SeriesSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);

    final ThemeData themeData = Theme.of(context);
    final ActionBarThemeData actionBarData =
        ActionBarThemeData(data: themeData);

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(left: 4.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Semantics(
                label: I18n.of(context).text('sm-series-actionbar-sort-by'),
                button: true,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: <Widget>[
                      ExcludeSemantics(
                        child: Text(
                          I18n.of(context).text('actionbar-sort-name'),
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Icon(
                        sortProvider.order == SeriesSortOrder.name_ascending
                            ? Icons.arrow_upward
                            : Icons.arrow_downward,
                        size: 22,
                        color: actionBarData.iconColor,
                      )
                    ],
                  ),
                ),
              ),
              onTap: () {
                sortProvider.toggleSortOrder();
              },
            ),
            InkWell(
              child: Semantics(
                label: I18n.of(context).text('actionbar-viewas-title'),
                button: true,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: ExcludeSemantics(
                    child: Icon(
                      Icons.view_list,
                      size: 26,
                      color: actionBarData.iconColor,
                    ),
                  ),
                ),
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
