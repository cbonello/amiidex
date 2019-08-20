import 'package:amiidex/UI/widgets/amiibo_actionbar.dart';
import 'package:amiidex/UI/widgets/detail.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:provider/provider.dart';

class CustomSearchDelegate extends SearchDelegate<AmiiboModel> {
  CustomSearchDelegate(this.amiibo);

  final AmiiboList amiibo;

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
      icon: const Icon(Icons.arrow_back),
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
        icon: const Icon(Icons.clear),
        onPressed: () => query = '',
      ),
    ];
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    assert(context != null);
    final AmiiboList suggestions = _search(context, query, minLength: 2);
    if (suggestions.isEmpty) {
      return Container();
    }
    return _displayMatches(suggestions);
  }

  @override
  Widget buildResults(BuildContext context) {
    assert(context != null);
    final AmiiboList results = _search(context, query);
    if (results.isEmpty) {
      return Container();
    }
    return _displayMatches(results);
  }

  AmiiboList _search(BuildContext context, String query, {int minLength = 1}) {
    assert(context != null);
    query = query.trim();
    if (query.length < minLength) {
      return AmiiboList();
    }

    final RegExp regex = _queryToPattern(query);
    if (regex.pattern.isEmpty) {
      return AmiiboList();
    }
    final List<AmiiboModel> matches = amiibo.where(
      (AmiiboModel a) {
        final String name = I18n.of(context).text(a.id);
        final bool m = regex.hasMatch(name);
        return m;
      },
    ).toList();
    return AmiiboList.from(matches);
  }

  Widget _displayMatches(AmiiboList matches) {
    return MultiProvider(
      providers: <SingleChildCloneableWidget>[
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
        body: DetailWidget(amiibo: matches),
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
