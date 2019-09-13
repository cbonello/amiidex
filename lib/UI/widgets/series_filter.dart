import 'package:amiidex/main.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/providers/series_filter.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/util/form.dart';
import 'package:amiidex/util/i18n.dart';
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
    final List<String> savedFilters = filterProvider.filters;

    return SeriesFilterWidget(savedFilters: savedFilters);
  }
}

class SeriesFilterWidget extends StatefulWidget {
  const SeriesFilterWidget({
    Key key,
    @required this.savedFilters,
  }) : super(key: key);

  final List<String> savedFilters;

  @override
  _SeriesFilterWidgetState createState() => _SeriesFilterWidgetState();
}

class _SeriesFilterWidgetState extends State<SeriesFilterWidget> {
  bool _saveNeeded;

  @override
  void initState() {
    _saveNeeded = false;
    super.initState();
  }

  Future<bool> _onWillPop() async {
    _saveNeeded = _saveNeeded;
    if (!_saveNeeded) {
      return true;
    }

    final ThemeData theme = Theme.of(context);
    final TextStyle dialogTextStyle = theme.textTheme.subhead.copyWith(
      color: theme.textTheme.caption.color,
    );
    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context, listen: false);

    return await showDialog<bool>(
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
                    filterProvider.filters = widget.savedFilters;
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
    final AssetsService _assetsService = locator<AssetsService>();
    final SeriesFilterProvider filterProvider =
        Provider.of<SeriesFilterProvider>(context, listen: false);
    final List<SerieModel> series = _assetsService.config.serieList;

    series.sort((SerieModel a, SerieModel b) {
      final String aName = I18n.of(context).text(a.lKey);
      final String bName = I18n.of(context).text(b.lKey);
      return aName.compareTo(bName);
    });

    return Scaffold(
      appBar: AppBar(
        title: Text(I18n.of(context).text('series-filter-title')),
        actions: <Widget>[
          FlatButton(
            child: Text(
              I18n.of(context).text('series-filter-save'),
              style: theme.textTheme.body1.copyWith(color: Colors.white),
            ),
            onPressed: () {
              Navigator.pop(context, DismissDialogAction.SAVE);
            },
          ),
        ],
        bottom: PreferredSize(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(20.0, 10.0, 15.0, 10.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: <Widget>[
                RaisedButton(
                  child:
                      Text(I18n.of(context).text('series-filter-select-all')),
                  onPressed: () {
                    filterProvider.setAll();
                    _saveNeeded = true;
                  },
                ),
                RaisedButton(
                  child:
                      Text(I18n.of(context).text('series-filter-deselect-all')),
                  onPressed: () {
                    filterProvider.clear();
                    _saveNeeded = true;
                  },
                ),
                RaisedButton(
                  child: Text(I18n.of(context).text('series-filter-reset')),
                  onPressed: () {
                    filterProvider.filters = widget.savedFilters;
                    _saveNeeded = false;
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
                    return LabeledCheckbox(
                      label: I18n.of(context).text(series[i].lKey),
                      padding: const EdgeInsets.all(2.0),
                      value: provider.isFiltered(series[i].lKey),
                      onChanged: (bool value) {
                        setState(() {
                          provider.toggleFilter(series[i].lKey);
                          _saveNeeded = true;
                        });
                      },
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
}
