import 'dart:collection';

import 'package:amiidex/models/serie.dart';
import 'package:amiidex/services/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';

// The list of series filtered.
class SeriesFilterProvider with ChangeNotifier {
  SeriesFilterProvider() {
    // Constraints:
    // 1) Provider must be inserted in the widget tree above MaterialApp to be
    //    accessible to the widgets created by onGenerateRoute().
    // 2) Provider depends on the assets service, which is not available when
    //    the provider is created.
    _providerInitialized = false;
  }

  bool _providerInitialized;
  final AssetsService _assetsService = locator<AssetsService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();
  final List<String> _series = <String>[];

  List<String> get filters {
    _performInitialization();
    return <String>[..._series];
  }

  set filters(List<String> serieIds) {
    // Call to _performInitialization() not required since _series will be
    // overwritten.
    for (String id in serieIds) {
      assert(_assetsService.config.isValidSerieId(id));
    }
    _series
      ..clear()
      ..addAll(serieIds);
    notifyListeners();
  }

  UnmodifiableListView<String> get filteredSerieIds {
    _performInitialization();
    return UnmodifiableListView<String>(_series);
  }

  bool isFiltered(String serieId) {
    _performInitialization();
    return _series.contains(serieId);
  }

  bool isUnfiltered(String serieId) {
    _performInitialization();
    return _series.contains(serieId) == false;
  }

  void addFilter(SerieModel s) {
    _performInitialization();
    if (isUnfiltered(s.lKey)) {
      _series.add(s.lKey);
      _storageService.setSeriesFilter(_series);
      notifyListeners();
    }
  }

  void toggleFilter(String serieId) {
    _performInitialization();
    if (isFiltered(serieId)) {
      _series.remove(serieId);
    } else {
      _series.add(serieId);
    }
    _storageService.setSeriesFilter(_series);
    notifyListeners();
  }

  void setAll() {
    final List<String> serieIds = _assetsService.config.serieList
        .map<String>((SerieModel s) => s.lKey)
        .toList();

    _series
      ..clear()
      ..addAll(serieIds);
    notifyListeners();
  }

  void clear() {
    _performInitialization();
    _series.clear();
    _storageService.setSeriesFilter(_series);
    notifyListeners();
  }

  void _performInitialization() {
    if (_providerInitialized == false) {
      final List<String> serieIds = _assetsService.config.serieList
          .map<String>((SerieModel s) => s.lKey)
          .toList();

      _series
        ..clear()
        ..addAll(_storageService.getSeriesFilter(serieIds));
      _providerInitialized = true;
    }
  }
}
