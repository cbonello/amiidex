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
  final List<String> _seriesID = <String>[];
  final List<SerieModel> _series = <SerieModel>[];

  List<String> get seriesID {
    _performInitialization();
    return <String>[..._seriesID];
  }

  set seriesID(List<String> serieIDs) {
    // Call to _performInitialization() not required since _seriesID and
    // _series  will be overwritten.
    for (final String id in serieIDs) {
      assert(_assetsService.config.isValidSerieID(id));
    }

    _seriesID
      ..clear()
      ..addAll(serieIDs);
    _setSeries();
    _storageService.setSeriesFilter(_seriesID);
    notifyListeners();
  }

  List<SerieModel> get series {
    _performInitialization();
    return <SerieModel>[..._series];
  }

  bool isFilteredIn(String serieId) {
    _performInitialization();
    return _seriesID.contains(serieId);
  }

  bool isFilteredOut(String serieId) {
    _performInitialization();
    return isFilteredIn(serieId) == false;
  }

  void _performInitialization() {
    if (_providerInitialized == false) {
      // Default value for shared preferences: all series.
      final List<String> serieIds = _assetsService.config.serieList
          .map<String>((SerieModel s) => s.lKey)
          .toList();

      _seriesID
        ..clear()
        ..addAll(_storageService.getSeriesFilter(serieIds));

      _setSeries();
      _providerInitialized = true;
    }
  }

  void _setSeries() {
    _series.clear();
    for (final String id in _seriesID) {
      _series.add(_assetsService.config.serie(id));
    }
  }
}
