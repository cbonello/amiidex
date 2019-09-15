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
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:provider/provider.dart';

class SeriesView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final ScrollController _controller = ScrollController();
    final FABVisibility fabVisibility = Provider.of<FABVisibility>(
      context,
      listen: false,
    );

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
        child: Consumer<SeriesFilterProvider>(
          builder: (
            BuildContext context,
            SeriesFilterProvider filterProvider,
            __,
          ) {
            final List<AmiiboModel> amiibo2Search = <AmiiboModel>[];
            for (SerieModel s in filterProvider.series) {
              amiibo2Search.addAll(s.amiibos);
            }

            return NestedScrollView(
              controller: _controller,
              headerSliverBuilder:
                  (BuildContext context, bool innerBoxIsScrolled) {
                return <Widget>[
                  SearchBar(
                    amiibo: UnmodifiableListView<AmiiboModel>(amiibo2Search),
                  ),
                  SerieActionBar(),
                ];
              },
              body: filterProvider.series.isNotEmpty
                  ? MasterWidget(series: filterProvider.series)
                  : Center(
                      child: Text(
                        I18n.of(context).text('master-nothing-to-display'),
                      ),
                    ),
            );
          },
        ),
      ),
    );
  }
}
