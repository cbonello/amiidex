import 'dart:collection';

import 'package:amiidex/UI/widgets/master.dart';
import 'package:amiidex/UI/widgets/search_bar.dart';
import 'package:amiidex/UI/widgets/serie_actionbar.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/providers/series_filter.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/services/assets.dart';
import 'package:provider/provider.dart';

class SeriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    final AssetsService assetsService = locator<AssetsService>();
    final FABVisibility fabVisibility = Provider.of<FABVisibility>(
      context,
      listen: false,
    );
    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context);
    final List<SerieModel> series = assetsService.config.serieList
        .where((SerieModel s) => filterProvider.isFiltered(s.lKey))
        .toList();

    _controller.addListener(
      () => fabVisibility.visible =
          _controller.position.userScrollDirection == ScrollDirection.forward,
    );

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<SeriesSortProvider>(
          builder: (_) => SeriesSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.series),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            final AssetsService assetsService = locator<AssetsService>();
            return <Widget>[
              SearchBar(
                amiibo: UnmodifiableListView<AmiiboModel>(
                  assetsService.config.amiiboList,
                ),
              ),
              SerieActionBar(),
            ];
          },
          body: series.isNotEmpty
              ? MasterWidget(series: series)
              : Center(
                  child:
                      Text(I18n.of(context).text('master-nothing-to-display')),
                ),
        ),
      ),
    );
  }
}
