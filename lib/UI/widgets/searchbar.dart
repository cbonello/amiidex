import 'package:floating_search_bar/ui/sliver_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:amiidex/util/search.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.amiibo, // List of amiibo that can be searched for.
  }) : super(key: key);

  final AmiiboList amiibo;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final LockProvider lockProvider = Provider.of<LockProvider>(context);

    return SliverFloatingBar(
      floating: true,
      snap: true,
      leading: IconButton(
        icon: Icon(
          Icons.menu,
          color: themeData.iconTheme.color,
          semanticLabel: I18n.of(context).text('sm-drawer'),
        ),
        onPressed: () => Scaffold.of(context).openDrawer(),
      ),
      title: GestureDetector(
        child: Text(
          I18n.of(context).text('collection-search'),
          style: themeData.textTheme.subhead,
        ),
        onTap: () async {
          await showSearch(
            context: context,
            delegate: CustomSearchDelegate(amiibo),
          );
        },
      ),
      trailing: InkWell(
        // Color must be explicitly set for light theme...
        child: lockProvider.isLocked
            ? Icon(
                Icons.lock,
                color: themeData.iconTheme.color,
                semanticLabel: I18n.of(context).text('sm-collection-locked'),
              )
            : Icon(
                Icons.lock_open,
                color: themeData.iconTheme.color,
                semanticLabel: I18n.of(context).text('sm-collection-unlocked'),
              ),
        onTap: () {
          if (lockProvider.isLocked) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(I18n.of(context).text('collection-locked')),
              ),
            );
          } else {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(I18n.of(context).text('collection-unlocked')),
              ),
            );
          }
          lockProvider.toggleLock();
        },
      ),
    );
  }
}
