import 'package:amiidex/UI/widgets/amiibo_grid_item.dart';
import 'package:amiidex/UI/widgets/amiibo_list_item.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/region.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/columns.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';

class DetailWidget extends StatefulWidget {
  const DetailWidget({
    Key key,
    @required this.amiibo,
    this.helpMessageDelegate,
  }) : super(key: key);

  final AmiiboList amiibo;
  final Function helpMessageDelegate;

  @override
  _DetailWidgetState createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    // final FABVisibility fabVisibility = Provider.of<FABVisibility>(context);
    final RegionProvider regionProvider = Provider.of<RegionProvider>(context);
    final AmiiboSortProvider sortProvider =
        Provider.of<AmiiboSortProvider>(context);
    final ViewAsProvider viewAsProvider = Provider.of<ViewAsProvider>(context);
    // final ScrollController _controller = ScrollController();

    if (widget.amiibo.isEmpty) {
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

    widget.amiibo.sortByNameRegion(
      context,
      sortProvider.order,
      regionProvider.regionId,
    );

    return viewAsProvider.viewAs == DisplayType.list
        ? ListView.builder(
            // controller: _controller,
            itemCount: widget.amiibo.length,
            itemBuilder: (BuildContext context, int position) {
              return AmiiboListItem(
                amiibo: widget.amiibo[position],
                helpMessageDelegate: widget.helpMessageDelegate,
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
            children: widget.amiibo
                .map<AmiiboGridItem>(
                  (AmiiboModel a) => AmiiboGridItem(
                    amiibo: a,
                    helpMessageDelegate: widget.helpMessageDelegate,
                  ),
                )
                .toList(),
          );
  }
}
