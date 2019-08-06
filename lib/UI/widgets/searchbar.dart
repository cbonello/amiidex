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
    @required this.amiibo, // List of amiibo to search.
  }) : super(key: key);

  final AmiiboList amiibo;

  @override
  Widget build(BuildContext context) {
    final LockProvider lockProvider = Provider.of<LockProvider>(context);

    return SliverFloatingBar(
      floating: true,
      snap: true,
      title: GestureDetector(
        child: Text(
          I18n.of(context).text('collection-search'),
          style: Theme.of(context).textTheme.subhead,
        ),
        onTap: () async {
          await showSearch(
            context: context,
            delegate: CustomSearchDelegate(
              amiibo,
            ),
          );
        },
      ),
      trailing: InkWell(
        child: lockProvider.isLocked
            ? const Icon(Icons.lock)
            : const Icon(Icons.lock_open),
        onTap: () {
          if (lockProvider.isLocked) {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  I18n.of(context).text('collection-locked'),
                ),
              ),
            );
          } else {
            Scaffold.of(context).removeCurrentSnackBar();
            Scaffold.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  I18n.of(context).text('collection-unlocked'),
                ),
              ),
            );
          }
          lockProvider.toggleLock();
        },
      ),
    );
  }
}
