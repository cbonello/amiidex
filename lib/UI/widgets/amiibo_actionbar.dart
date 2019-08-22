import 'package:amiidex/UI/widgets/actionbar_bottomsheet_item.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/actionbar_region_bottomsheet.dart';
import 'package:amiidex/util/actionbar_viewas_bottomsheet.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/theme.dart';
import 'package:provider/provider.dart';

class AmiiboActionBar extends StatefulWidget {
  @override
  _AmiiboActionBarState createState() => _AmiiboActionBarState();
}

class _AmiiboActionBarState extends State<AmiiboActionBar> {
  @override
  Widget build(BuildContext context) {
    final RegionProvider regionProvider = Provider.of<RegionProvider>(context);
    final AmiiboSortProvider sortProvider =
        Provider.of<AmiiboSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);
    final List<String> sortLabels = <String>[
      I18n.of(context).text('actionbar-sort-name'),
      I18n.of(context).text('actionbar-sort-name'),
      I18n.of(context).text('actionbar-sort-release-date'),
      I18n.of(context).text('actionbar-sort-release-date'),
    ];
    const List<IconData> sortIcons = <IconData>[
      Icons.arrow_upward,
      Icons.arrow_downward,
      Icons.arrow_upward,
      Icons.arrow_downward,
    ];
    const List<AmiiboSortOrder> reverseSort = <AmiiboSortOrder>[
      AmiiboSortOrder.name_descending,
      AmiiboSortOrder.name_ascending,
      AmiiboSortOrder.release_date_descending,
      AmiiboSortOrder.release_date_ascending,
    ];

    bool isNameSort(AmiiboSortOrder current) {
      return <AmiiboSortOrder>[
        AmiiboSortOrder.name_ascending,
        AmiiboSortOrder.name_descending
      ].contains(current);
    }

    bool isReleaseDateSort(AmiiboSortOrder current) {
      return <AmiiboSortOrder>[
        AmiiboSortOrder.release_date_ascending,
        AmiiboSortOrder.release_date_descending
      ].contains(current);
    }

    final ThemeData themeData = Theme.of(context);
    final ActionBarThemeData actionBarData =
        ActionBarThemeData(data: themeData);

    Future<void> _sortModalBottomSheet(AmiiboSortOrder current) async {
      await showModalBottomSheet<void>(
        shape: RoundedRectangleBorder(
          borderRadius: const BorderRadius.all(Radius.circular(12.0)),
        ),
        context: context,
        builder: (BuildContext bc) {
          return Container(
            child: Wrap(
              children: <Widget>[
                ListTile(
                  title: Text(
                    I18n.of(context).text('amiibo-actionbar-sort-by'),
                    semanticsLabel:
                        I18n.of(context).text('sm-amiibo-actionbar-sort-by'),
                  ),
                ),
                const Divider(height: 8),
                ActionBarBottomSheetItem(
                  displayIcon: isNameSort(current),
                  leading: sortIcons[current.index],
                  title: sortLabels[AmiiboSortOrder.name_ascending.index],
                  semanticLabel:
                      I18n.of(context).text('sm-actionbar-sort-name'),
                  selected: isNameSort(current),
                  onTap: () {
                    sortProvider.order = isNameSort(current)
                        ? reverseSort[current.index]
                        : AmiiboSortOrder.name_ascending;
                    Navigator.pop<void>(context);
                  },
                ),
                ActionBarBottomSheetItem(
                  displayIcon: isReleaseDateSort(current),
                  leading: sortIcons[current.index],
                  title:
                      sortLabels[AmiiboSortOrder.release_date_ascending.index],
                  semanticLabel:
                      I18n.of(context).text('sm-actionbar-sort-release-date'),
                  selected: isReleaseDateSort(current),
                  onTap: () {
                    sortProvider.order = isReleaseDateSort(current)
                        ? reverseSort[current.index]
                        : AmiiboSortOrder.release_date_ascending;
                    Navigator.pop<void>(context);
                  },
                ),
              ],
            ),
          );
        },
      );
    }

    return SliverToBoxAdapter(
      child: Container(
        padding: const EdgeInsets.only(
          left: 14.0,
          top: 14.0,
          right: 10.0,
          bottom: 14.0,
        ),
        color: Theme.of(context).canvasColor,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            InkWell(
              child: Semantics(
                label: I18n.of(context).text('amiibo-actionbar-sort-by'),
                button: true,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Row(
                    children: <Widget>[
                      ExcludeSemantics(
                        child: Text(
                          sortLabels[sortProvider.order.index],
                          style: Theme.of(context).textTheme.subhead,
                        ),
                      ),
                      const SizedBox(width: 2.0),
                      Icon(
                        sortProvider.order == AmiiboSortOrder.name_ascending ||
                                sortProvider.order ==
                                    AmiiboSortOrder.release_date_ascending
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
                _sortModalBottomSheet(sortProvider.order);
              },
            ),
            InkWell(
              child: Semantics(
                label: I18n.of(context).text('actionbar-region-title'),
                button: true,
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: ExcludeSemantics(
                    child: Text(
                      I18n.of(context).text(regionProvider.regionName),
                      style: Theme.of(context).textTheme.subhead,
                    ),
                  ),
                ),
              ),
              onTap: () {
                showRegionsBottomSheet(context, regionProvider.regionId);
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
