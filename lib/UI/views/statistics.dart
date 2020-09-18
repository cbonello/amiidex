import 'dart:collection';

import 'package:amiidex/UI/widgets/owned_missing_pie_chart.dart';
import 'package:amiidex/UI/widgets/search_bar.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/providers/series_filter.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class StatisticsView extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final FABVisibility fabVisibility = Provider.of<FABVisibility>(
      context,
      listen: false,
    );
    final ScrollController _controller = ScrollController();

    _controller.addListener(
      () => fabVisibility.visible =
          _controller.position.userScrollDirection == ScrollDirection.forward,
    );

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<AmiiboSortProvider>(
          create: (_) => AmiiboSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          create: (_) => ViewAsProvider(ItemsDisplayed.statictics),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Consumer<OwnedProvider>(builder: (
          BuildContext context,
          OwnedProvider ownedProvider,
          __,
        ) {
          return Consumer<SeriesFilterProvider>(
            builder: (
              BuildContext context,
              SeriesFilterProvider filterProvider,
              __,
            ) {
              final List<AmiiboModel> amiibo2Search = <AmiiboModel>[];
              double ownedCount = 0;
              for (final SerieModel s in filterProvider.series) {
                for (final AmiiboModel a in s.amiibos) {
                  amiibo2Search.add(a);
                  if (ownedProvider.isOwned(a.lKey)) {
                    ownedCount++;
                  }
                }
              }
              final double missedCount =
                  amiibo2Search.length.toDouble() - ownedCount;

              return NestedScrollView(
                controller: _controller,
                headerSliverBuilder:
                    (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SearchBar(
                      amiibo: UnmodifiableListView<AmiiboModel>(amiibo2Search),
                    ),
                  ];
                },
                body: Column(
                  children: <Widget>[
                    const SizedBox(height: 50.0),
                    Text(
                      sprintf(
                        I18n.of(context).text('stats-amiibo-count'),
                        <int>[
                          amiibo2Search.length.toInt(),
                        ],
                      ),
                      style: Theme.of(context).textTheme.title,
                    ),
                    amiibo2Search.isNotEmpty
                        ? OwnedMissingPieChart(
                            ownedCount: ownedCount,
                            missedCount: missedCount,
                          )
                        : Expanded(
                            child: Center(
                              child: Text(
                                I18n.of(context)
                                    .text('master-nothing-to-display'),
                              ),
                            ),
                          ),
                  ],
                ),
              );
            },
          );
        }),
      ),
    );
  }
}
