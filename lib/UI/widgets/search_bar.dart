import 'dart:collection';

import 'package:amiidex/UI/widgets/amiibo_actionbar.dart';
import 'package:amiidex/UI/widgets/amiibos.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:floating_search_bar/ui/sliver_search_bar.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';

class SearchBar extends StatelessWidget {
  const SearchBar({
    Key key,
    @required this.amiibo, // List of amiibo that can be searched for.
  }) : super(key: key);

  final UnmodifiableListView<AmiiboModel> amiibo;

  @override
  Widget build(BuildContext context) {
    final ThemeData themeData = Theme.of(context);
    final LockProvider lockProvider = Provider.of<LockProvider>(context);

    return SliverFloatingBar(
        floating: true,
        snap: true,
        leading: IconButton(
          padding: const EdgeInsets.all(6.0),
          icon: Icon(
            Icons.menu,
            color: themeData.iconTheme.color,
            semanticLabel: I18n.of(context).text('sm-drawer'),
          ),
          onPressed: () => Scaffold.of(context).openDrawer(),
        ),
        title: GestureDetector(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(2.0, 16.0, 2.0, 16.0),
            child: Text(
              I18n.of(context).text('collection-search'),
              style: themeData.textTheme.subhead,
            ),
          ),
          onTap: () async {
            await SystemSound.play(SystemSoundType.click);
            await showSearch<AmiiboModel>(
              context: context,
              delegate: CustomSearchDelegate(amiibo),
            );
          },
        ),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            InkWell(
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 15.0, 16.0),
                child: Icon(
                  Icons.filter_list,
                  color: themeData.iconTheme.color,
                  semanticLabel: I18n.of(context).text('sm-filter-series'),
                ),
              ),
              onTap: () {
                Navigator.pushNamed(context, '/filter_series');
              },
            ),
            InkWell(
              // Color must be explicitly set for light theme...
              child: Padding(
                padding: const EdgeInsets.fromLTRB(12.0, 16.0, 12.0, 16.0),
                child: lockProvider.isLocked
                    ? Icon(
                        Icons.lock,
                        color: themeData.iconTheme.color,
                        semanticLabel:
                            I18n.of(context).text('sm-collection-locked'),
                      )
                    : Icon(
                        Icons.lock_open,
                        color: themeData.iconTheme.color,
                        semanticLabel:
                            I18n.of(context).text('sm-collection-unlocked'),
                      ),
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
                      content:
                          Text(I18n.of(context).text('collection-unlocked')),
                    ),
                  );
                }
                lockProvider.toggleLock();
              },
            ),
          ],
        ));
  }
}

class CustomSearchDelegate extends SearchDelegate<AmiiboModel> {
  CustomSearchDelegate(this.amiibo);

  final UnmodifiableListView<AmiiboModel> amiibo;

  @override
  ThemeData appBarTheme(BuildContext context) {
    assert(context != null);
    final ThemeData theme = Theme.of(context);
    assert(theme != null);
    return theme.copyWith(
      primaryColor: theme.appBarTheme.color,
      primaryIconTheme: theme.appBarTheme.iconTheme,
      primaryColorBrightness: theme.brightness,
      primaryTextTheme: theme.appBarTheme.textTheme,
    );
  }

  @override
  Widget buildLeading(BuildContext context) {
    assert(context != null);
    return IconButton(
      icon: Icon(
        Icons.arrow_back,
        semanticLabel: I18n.of(context).text('sm-back'),
      ),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  List<Widget> buildActions(BuildContext context) {
    assert(context != null);
    return <IconButton>[
      IconButton(
        icon: Icon(
          Icons.clear,
          semanticLabel: I18n.of(context).text('sm-clear'),
        ),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    assert(context != null);
    final List<AmiiboModel> suggestions = _search(context, query, minLength: 2);
    if (suggestions.isEmpty) {
      return Container();
    }
    return _displayMatches(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) {
    assert(context != null);
    final List<AmiiboModel> results = _search(context, query);
    if (results.isEmpty) {
      return Container();
    }
    return _displayMatches(results);
  }

  List<AmiiboModel> _search(BuildContext context, String query,
      {int minLength = 1}) {
    assert(context != null);
    query = query.trim();
    if (query.length < minLength) {
      return <AmiiboModel>[];
    }

    final RegExp regex = _queryToPattern(query);
    if (regex.pattern.isEmpty) {
      return <AmiiboModel>[];
    }
    final List<AmiiboModel> matches = amiibo.where(
      (AmiiboModel a) {
        final String name = I18n.of(context).text(a.lKey);
        final bool m = regex.hasMatch(name);
        return m;
      },
    ).toList();
    return List<AmiiboModel>.from(matches);
  }

  Widget _displayMatches(List<AmiiboModel> matches) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
        ChangeNotifierProvider<AmiiboSortProvider>(
          builder: (_) => AmiiboSortProvider(),
        ),
        ChangeNotifierProvider<ViewAsProvider>(
          builder: (_) => ViewAsProvider(ItemsDisplayed.searches),
        ),
      ],
      child: NestedScrollView(
        headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
          return <Widget>[
            AmiiboActionBar(),
          ];
        },
        body: AmiibosWidget(amiibos: matches),
      ),
    );
  }

  // Transform query into regular expression.
  RegExp _queryToPattern(String str) {
    final List<String> keywords = str
        .split(' ')
        .map<String>((String keyword) => keyword.trim().toLowerCase())
        .where((String keyword) => keyword.isNotEmpty)
        .toSet() // Remove duplicates.
        .toList();
    String pattern = '';
    if (keywords.isNotEmpty) {
      pattern = keywords[0];
      for (int i = 1; i < keywords.length; i++) {
        pattern += '|' + keywords[i];
      }
    }
    return RegExp(
      pattern,
      caseSensitive: false,
      multiLine: false,
    );
  }
}
