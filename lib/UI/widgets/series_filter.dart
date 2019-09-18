import 'package:amiidex/main.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/providers/series_filter.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/form.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

enum DismissDialogAction {
  CANCEL,
  DISCARD,
  SAVE,
}

class SeriesFiltersDialog extends StatefulWidget {
  @override
  _SeriesFiltersDialogState createState() => _SeriesFiltersDialogState();
}

class _SeriesFiltersDialogState extends State<SeriesFiltersDialog> {
  @override
  Widget build(BuildContext context) {
    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context, listen: false);
    final List<String> savedFilters = filterProvider.seriesID;

    return _SeriesFilterWidget(savedFilters: savedFilters);
  }
}

class _SeriesFilterWidget extends StatefulWidget {
  const _SeriesFilterWidget({
    Key key,
    @required this.savedFilters,
  }) : super(key: key);

  final List<String> savedFilters;

  @override
  _SeriesFilterWidgetState createState() => _SeriesFilterWidgetState();
}

class _SeriesFilterWidgetState extends State<_SeriesFilterWidget> {
  final AssetsService assetsService = locator<AssetsService>();
  final List<String> filteredSeriesID = <String>[];
  bool saveNeeded;

  @override
  void initState() {
    filteredSeriesID.addAll(widget.savedFilters);
    saveNeeded = false;
    super.initState();
  }

  Future<bool> _onWillPop() async {
    saveNeeded = saveNeeded;
    if (!saveNeeded) {
      return true;
    }

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(
      color: theme.textTheme.caption.color,
    );

    return showDialog<bool>(
          context: context,
          builder: (BuildContext context) {
            return AlertDialog(
              content: Text(
                I18n.of(context).text('series-filter-discard-question'),
                style: dialogTextStyle,
              ),
              actions: <Widget>[
                FlatButton(
                  child: Text(I18n.of(context).text('series-filter-cancel')),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                FlatButton(
                  child: Text(I18n.of(context).text('series-filter-discard')),
                  onPressed: () {
                    Navigator.of(context).pop(true);
                  },
                ),
              ],
            );
          },
        ) ??
        false;
  }

  @override
  Widget build(BuildContext context) {
    final ThemeData theme = Theme.of(context);
    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context, listen: false);
    final List<SerieModel> series = assetsService.config.serieList;

    series.sort((SerieModel a, SerieModel b) {
      final String aName = I18n.of(context).text(a.lKey);
      final String bName = I18n.of(context).text(b.lKey);
      return aName.compareTo(bName);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('series-filter-title')),
        actions: <Widget>[
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16.0),
            child: FlatButton(
              child: Text(
                I18n.of(context).text('series-filter-save'),
                style: theme.textTheme.title,
              ),
              onPressed: () {
                if (listEquals(
                      filterProvider.seriesID,
                      filteredSeriesID,
                    ) ==
                    false) {
                  filterProvider.seriesID = filteredSeriesID;
                }
                Navigator.pop(context, DismissDialogAction.SAVE);
              },
              padding: const EdgeInsets.symmetric(vertical: 3.0),
            ),
          ),
        ],
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 15.0, 10.0),
            child: Container(
              height: 48.0,
              child: ListView(
                scrollDirection: Axis.horizontal,
                children: <Widget>[
                  RaisedButton(
                    child: Text(
                      I18n.of(context).text(
                        'series-filter-select-all',
                      ),
                    ),
                    onPressed: () {
                      _setAll();
                      saveNeeded = true;
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      I18n.of(context).text(
                        'series-filter-deselect-all',
                      ),
                    ),
                    onPressed: () {
                      _clear();
                      saveNeeded = true;
                    },
                  ),
                  RaisedButton(
                    child: Text(
                      I18n.of(context).text(
                        'series-filter-reset',
                      ),
                    ),
                    onPressed: () {
                      setState(() {
                        filteredSeriesID.clear();
                        filteredSeriesID.addAll(widget.savedFilters);
                      });
                      saveNeeded = false;
                    },
                  ),
                ]
                    .map<Widget>(
                      (Widget w) => Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 5.0),
                        child: w,
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
          preferredSize: const Size(0.0, 50.0),
        ),
      ),
      body: Form(
        onWillPop: _onWillPop,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Scrollbar(
            child: ListView.separated(
              itemCount: series.length,
              separatorBuilder: (BuildContext context, int index) =>
                  const Divider(),
              itemBuilder: (BuildContext context, int i) {
                return Consumer<SeriesFilterProvider>(
                  builder: (_, SeriesFilterProvider provider, Widget child) {
                    final String label = I18n.of(context).text(series[i].lKey);
                    final bool value = filteredSeriesID.contains(
                      series[i].lKey,
                    );
                    return Semantics(
                      label: label,
                      checked: value,
                      child: LabeledCheckbox(
                        label: label,
                        padding: const EdgeInsets.all(2.0),
                        value: value,
                        onChanged: (bool value) {
                          setState(() {
                            _toggleFilter(series[i].lKey);
                            saveNeeded = true;
                          });
                        },
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ),
      ),
    );
  }

  void _setAll() {
    final List<String> serieIds = assetsService.config.serieList
        .map<String>((SerieModel s) => s.lKey)
        .toList();

    setState(() {
      filteredSeriesID
        ..clear()
        ..addAll(serieIds);
    });
  }

  void _toggleFilter(String serieId) {
    setState(() {
      if (filteredSeriesID.contains(serieId)) {
        filteredSeriesID.remove(serieId);
      } else {
        filteredSeriesID.add(serieId);
      }
    });
  }

  void _clear() {
    setState(() => filteredSeriesID.clear());
  }
}
