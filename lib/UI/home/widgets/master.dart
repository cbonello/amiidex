import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/UI/home/widgets/serie_grid_item.dart';
import 'package:amiidex/UI/home/widgets/serie_list_item.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/models/serie_list.dart';
// import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/columns.dart';
import 'package:provider/provider.dart';

class MasterWidget extends StatelessWidget {
  final AssetsService assetsService = locator<AssetsService>();
  // final ScrollController _controller = ScrollController();

  @override
  Widget build(BuildContext context) {
    // final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);
    final SeriesSortProvider sortProvider =
        Provider.of<SeriesSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);
    final SeriesList series = assetsService.amiiboLineup.series;

    // _controller.addListener(() {
    //   if (_controller.position.userScrollDirection == ScrollDirection.forward) {
    //     fabVisibility.visible = true;
    //     print('forward');
    //   } else {
    //     fabVisibility.visible = false;
    //     print('backward');
    //   }
    // });

    series.sortByName(context, sortProvider.order);

    // Pass "series" to SerieListItem() and SerieGridItem() to allow swipping
    // between series in the sort order defined above. See DetailPage widget.
    return viewAsProvider.viewAs == DisplayType.list
        ? ListView.builder(
            // controller: _controller,
            itemCount: series.length,
            itemBuilder: (BuildContext context, int position) {
              return SerieListItem(
                series: series,
                serie: series[position],
              );
            },
          )
        : GridView.count(
            // controller: _controller,
            shrinkWrap: true,
            // primary: true,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            crossAxisCount: columnsCount(context, viewAsProvider),
            childAspectRatio: 1.0,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: series
                .map<SerieGridItem>(
                    (SerieModel s) => SerieGridItem(series: series, serie: s))
                .toList(),
          );
  }
}
