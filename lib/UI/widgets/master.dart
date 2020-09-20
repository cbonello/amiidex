import 'dart:collection';

import 'package:amiidex/UI/widgets/serie_grid_item.dart';
import 'package:amiidex/UI/widgets/serie_list_item.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
// import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/columns.dart';
import 'package:provider/provider.dart';

class MasterWidget extends StatelessWidget {
  const MasterWidget({Key key, @required this.series}) : super(key: key);

  final List<SerieModel> series;

  @override
  Widget build(BuildContext context) {
    // final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);
    final SeriesSortProvider sortProvider =
        Provider.of<SeriesSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);

    // _controller.addListener(() {
    //   if (_controller.position.userScrollDirection == ScrollDirection.forward) {
    //     fabVisibility.visible = true;
    //     print('forward');
    //   } else {
    //     fabVisibility.visible = false;
    //     print('backward');
    //   }
    // });

    if (sortProvider.order == SeriesSortOrder.name_ascending) {
      series.sort((SerieModel a, SerieModel b) {
        final String aName = I18n.of(context).text(a.lKey);
        final String bName = I18n.of(context).text(b.lKey);
        return aName.compareTo(bName);
      });
    } else {
      series.sort((SerieModel a, SerieModel b) {
        final String aName = I18n.of(context).text(a.lKey);
        final String bName = I18n.of(context).text(b.lKey);
        return bName.compareTo(aName);
      });
    }

    // Pass "series" to SerieListItem()/ SerieGridItem() to allow swipping
    // of series in current sort order.
    return Scrollbar(
      child: viewAsProvider.viewAs == DisplayType.list
          ? ListView.builder(
              // controller: _controller,
              key: const PageStorageKey<String>('seriesListView'),
              itemCount: series.length,
              itemBuilder: (BuildContext context, int position) {
                return SerieListItem(
                  series: UnmodifiableListView<SerieModel>(series),
                  serie: series[position],
                );
              },
            )
          : GridView.builder(
              // controller: _controller,
              key: const PageStorageKey<String>('seriesGridView'),
              shrinkWrap: true,
              // primary: true,
              padding: const EdgeInsets.only(left: 5.0, right: 5.0),
              itemCount: series.length,
              itemBuilder: (BuildContext context, int position) {
                return SerieGridItem(
                  series: UnmodifiableListView<SerieModel>(series),
                  serie: series[position],
                );
              },
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: columnsCount(context, viewAsProvider),
                childAspectRatio: 1.0,
                mainAxisSpacing: 1.0,
                crossAxisSpacing: 1.0,
              ),
            ),
    );
  }
}
