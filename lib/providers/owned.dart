import 'dart:collection';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/services/local_storage.dart';

// The list of amiibo owned.
class OwnedProvider with ChangeNotifier {
  OwnedProvider() {
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
  final List<String> _owned = <String>[];
  final Map<String, int> _ownedCountBySerie = <String, int>{};

  int get ownedCount {
    _performInitialization();
    return _owned.length;
  }

  UnmodifiableListView<String> get ownedAmiiboIds {
    _performInitialization();
    return UnmodifiableListView<String>(_owned);
  }

  bool isOwned(String amiiboId) {
    _performInitialization();
    return _owned.contains(amiiboId);
  }

  bool isMissed(String amiiboId) {
    _performInitialization();
    return _owned.contains(amiiboId) == false;
  }

  int ownedCountInSerie(SerieModel s) {
    _performInitialization();
    return _ownedCountBySerie[s.lKey];
  }

  double percentOwnedInSerie(SerieModel s) {
    _performInitialization();
    return ownedCountInSerie(s) / s.amiibos.length;
  }

  void setOwned(AmiiboModel a) {
    _performInitialization();
    if (isMissed(a.lKey)) {
      _ownedCountBySerie[a.serieID]++;
      _owned.add(a.lKey);
      assert(_ownedCountBySerie[a.serieID] >= 0 &&
          _ownedCountBySerie[a.serieID] <=
              _assetsService.config.seriesMap[a.serieID].amiibos.length);
      _storageService.setOwned(_owned);
      notifyListeners();
    }
  }

  void toggleAmiiboOwnership(String amiiboId) {
    _performInitialization();
    final AmiiboModel a = _assetsService.config.amiibo(amiiboId);

    if (isOwned(amiiboId)) {
      _ownedCountBySerie[a.serieID]--;
      _owned.remove(amiiboId);
    } else {
      _ownedCountBySerie[a.serieID]++;
      _owned.add(amiiboId);
    }
    assert(_ownedCountBySerie[a.serieID] >= 0 &&
        _ownedCountBySerie[a.serieID] <=
            _assetsService.config.seriesMap[a.serieID].amiibos.length);

    _storageService.setOwned(_owned);
    notifyListeners();
  }

  void reset() {
    _performInitialization();
    _owned.clear();
    _ownedCountBySerie.updateAll((String k, int v) => 0);
    _storageService.setOwned(_owned);
    notifyListeners();
  }

  void _performInitialization() {
    if (_providerInitialized == false) {
      _owned.addAll(_storageService.getOwned());
      final List<SerieModel> series =
          _assetsService.config.seriesMap.values.toList();
      for (SerieModel s in series) {
        _ownedCountBySerie[s.lKey] = s.amiibos
            .where(
              (AmiiboModel e) => _owned.contains(e.lKey),
            )
            .length;
      }
      _providerInitialized = true;
    }
  }
}
