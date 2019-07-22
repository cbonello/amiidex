import 'package:amiidex/UI/widgets/amiibo_actionbar.dart';
import 'package:amiidex/UI/widgets/detail.dart';
import 'package:amiidex/UI/widgets/searchbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/amiibo_list.dart';
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
    final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);
    final ScrollController _controller = ScrollController();

    _controller.addListener(
      () => fabVisibility.visible =
          _controller.position.userScrollDirection == ScrollDirection.forward,
    );

    final AssetsService assetsService = locator<AssetsService>();
    final OwnedProvider ownedProvider = Provider.of<OwnedProvider>(context);
    final AmiiboList ownedAmiibo = AmiiboList();
    for (String id in ownedProvider.ownedAmiiboIds) {
      ownedAmiibo.add(assetsService.amiiboLineup.getAmiiboById(id));
    }

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
        child: NestedScrollView(
          controller: _controller,
          headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
            return <Widget>[
              SearchBar(amiibo: ownedAmiibo),
              AmiiboActionBar(),
            ];
          },
          body: DetailWidget(
            amiibo: ownedAmiibo,
            helpMessageDelegate: (String amiiboName) => sprintf(
                I18n.of(context).text('owned-removed'), <String>[amiiboName]),
          ),
        ),
      ),
    );
  }
}