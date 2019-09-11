import 'package:amiidex/UI/widgets/amiibo_grid_item.dart';
import 'package:amiidex/UI/widgets/amiibo_list_item.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/selected_region.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/columns.dart';
import 'package:provider/provider.dart';

class AmiibosWidget extends StatelessWidget {
  const AmiibosWidget({
    Key key,
    @required this.amiibos,
    this.helpMessageDelegate,
  }) : super(key: key);

  final List<AmiiboModel> amiibos;
  final Function helpMessageDelegate;

  @override
  Widget build(BuildContext context) {
    // final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);
    final AmiiboSortProvider sortProvider =
        Provider.of<AmiiboSortProvider>(context);
    final SelectedRegionProvider regionProvider =
        Provider.of<SelectedRegionProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);
    // final ScrollController _controller = ScrollController();

    if (amiibos.isEmpty) {
      return Center(
        child: Text(I18n.of(context).text('detail-nothing-to-display')),
      );
    }

    // _controller.addListener(() {
    //   if (_controller.position.userScrollDirection == ScrollDirection.forward)
    //     fabVisibility.visible = true;
    //   else
    //     fabVisibility.visible = false;
    // });

    _sortAmiiboByNameRegion(
      context,
      amiibos,
      sortProvider.order,
      regionProvider.regionId,
    );

    return viewAsProvider.viewAs == DisplayType.list
        ? ListView.builder(
            // controller: _controller,
            itemCount: amiibos.length,
            itemBuilder: (BuildContext context, int position) {
              return AmiiboListItem(
                amiibo: amiibos[position],
                helpMessageDelegate: helpMessageDelegate,
              );
            },
          )
        : GridView.count(
            // controller: _controller,
            shrinkWrap: true,
            primary: true,
            padding: const EdgeInsets.only(left: 5.0, right: 5.0),
            crossAxisCount: columnsCount(context, viewAsProvider),
            childAspectRatio: 0.9,
            mainAxisSpacing: 1.0,
            crossAxisSpacing: 1.0,
            children: amiibos
                .map<AmiiboGridItem>(
                  (AmiiboModel a) => AmiiboGridItem(
                    amiibo: a,
                    helpMessageDelegate: helpMessageDelegate,
                  ),
                )
                .toList(),
          );
  }

  void _sortAmiiboByNameRegion(
    BuildContext context,
    List<AmiiboModel> amiibos,
    AmiiboSortOrder order,
    String regionId,
  ) {
    switch (order) {
      case AmiiboSortOrder.name_ascending:
        amiibos.sort((AmiiboModel a, AmiiboModel b) {
          final String aName = I18n.of(context).text(a.lKey);
          final String bName = I18n.of(context).text(b.lKey);
          return aName.compareTo(bName);
        });
        break;
      case AmiiboSortOrder.name_descending:
        amiibos.sort((AmiiboModel a, AmiiboModel b) {
          final String aName = I18n.of(context).text(a.lKey);
          final String bName = I18n.of(context).text(b.lKey);
          return bName.compareTo(aName);
        });
        break;
      case AmiiboSortOrder.release_date_ascending:
        final List<AmiiboModel> notReleasedInRegion =
            List<AmiiboModel>.from(amiibos)
              ..removeWhere(
                (AmiiboModel a) => a.wasReleasedInRegion(regionId),
              );
        final List<AmiiboModel> releasedInRegion =
            List<AmiiboModel>.from(amiibos)
              ..removeWhere(
                (AmiiboModel a) => a.wasReleasedInRegion(regionId) == false,
              );
        releasedInRegion.sort((AmiiboModel a, AmiiboModel b) {
          return a.releases[regionId].releaseDate
              .compareTo(b.releases[regionId].releaseDate);
        });
        amiibos.clear();
        amiibos.addAll(notReleasedInRegion);
        amiibos.addAll(releasedInRegion);
        break;
      case AmiiboSortOrder.release_date_descending:
        final List<AmiiboModel> notReleasedInRegion =
            List<AmiiboModel>.from(amiibos)
              ..removeWhere(
                (AmiiboModel a) => a.wasReleasedInRegion(regionId),
              );
        final List<AmiiboModel> releasedInRegion =
            List<AmiiboModel>.from(amiibos)
              ..removeWhere(
                (AmiiboModel a) => a.wasReleasedInRegion(regionId) == false,
              );
        releasedInRegion.sort((AmiiboModel a, AmiiboModel b) {
          return b.releases[regionId].releaseDate
              .compareTo(a.releases[regionId].releaseDate);
        });
        amiibos.clear();
        amiibos.addAll(notReleasedInRegion);
        amiibos.addAll(releasedInRegion);
        break;
      default:
        assert(false);
    }
  }
}
