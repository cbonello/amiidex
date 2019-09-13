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

class MissingView extends StatelessWidget {
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

    final AssetsService assetsService = locator<AssetsService>();
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);

    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context);
    final List<AmiiboModel> missedAmiibo =
        List<AmiiboModel>.from(assetsService.config.amiibos.values)
            .where((AmiiboModel a) => filterProvider.isFiltered(a.serieId))
            .toList();
    for (String id in ownedProvider.ownedAmiiboIds) {
      missedAmiibo.remove(assetsService.config.amiibo(id));
    }

    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<AmiiboSortProvider>(
          builder: (_) => AmiiboSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.missing),
        ),
      ],
      child: Padding(
        padding: const EdgeInsets.only(top: 5.0),
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SearchBar(
                amiibo: UnmodifiableListView<AmiiboModel>(missedAmiibo),
              ),
              AmiiboActionBar(),
            ];
          },
          body: AmiibosWidget(
            amiibos: missedAmiibo,
            helpMessageDelegate: (String amiiboName) => sprintf(
                I18n.of(context).text('missing-added'), <String>[amiiboName]),
          ),
        ),
      ),
    );
  }
}
