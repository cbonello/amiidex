import 'dart:collection';

import 'package:amiidex/UI/widgets/amiibo_actionbar.dart';
import 'package:amiidex/UI/widgets/amiibos.dart';
import 'package:amiidex/UI/widgets/search_bar.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/providers/series_filter.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/fab_visibility.dart';
import 'package:amiidex/providers/owned.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';
import 'package:sprintf/sprintf.dart';

class OwnedView extends StatelessWidget {
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
          builder: (_) => AmiiboSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.owned),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: Consumer<OwnedProvider>(
          builder: (BuildContext context, OwnedProvider ownedProvider, __) {
            return Consumer<SeriesFilterProvider>(
              builder: (
                BuildContext context,
                SeriesFilterProvider filterProvider,
                __,
              ) {
                final AssetsService assetsService = locator<AssetsService>();
                final List<AmiiboModel> ownedAmiibo = <AmiiboModel>[];
                for (String id in ownedProvider.ownedAmiiboIds) {
                  final AmiiboModel a = assetsService.config.amiibo(id);
                  if (filterProvider.isFilteredIn(a.serieID)) {
                    ownedAmiibo.add(a);
                  }
                }

                return NestedScrollView(
                  controller: _controller,
                  headerSliverBuilder:
                      (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SearchBar(
                        amiibo: UnmodifiableListView<AmiiboModel>(
                          ownedAmiibo,
                        ),
                      ),
                      AmiiboActionBar(),
                    ];
                  },
                  body: AmiibosWidget(
                    amiibos: ownedAmiibo,
                    helpMessageDelegate: (String amiiboName) => sprintf(
                      I18n.of(context).text('owned-removed'),
                      <String>[amiiboName],
                    ),
                  ),
                );
              },
            );
          },
        ),
      ),
    );
  }
}
