import 'dart:collection';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/services/local_storage.dart';

// List of owned amiibo.
class OwnedProvider with ChangeNotifier {
  OwnedProvider() {
    _owned.addAll(storageService.getOwned());
  }

  void init(List<SerieModel> series) {
    for (SerieModel s in series) {
      _ownedCountBySerie[s.lKey] = s.amiibos
          .where(
            (AmiiboModel e) => _owned.contains(e.lKey),
          )
          .length;
    }
  }

  final AssetsService assetsService = locator<AssetsService>();
  final LocalStorageService storageService = locator<LocalStorageService>();
  final List<String> _owned = <String>[];
  final Map<String, int> _ownedCountBySerie = <String, int>{};

  int get ownedCount => _owned.length;

  UnmodifiableListView<String> get ownedAmiiboIds =>
      UnmodifiableListView<String>(_owned);

  bool isOwned(String amiiboId) => _owned.contains(amiiboId);
  bool isMissed(String amiiboId) => _owned.contains(amiiboId) == false;

  int ownedInSerie(SerieModel s) => _ownedCountBySerie[s.lKey];

  double percentOwnedInSerie(SerieModel s) {
    return ownedInSerie(s) / s.amiibos.length;
  }

  void setOwned(AmiiboModel a) {
    if (isMissed(a.lKey)) {
      _ownedCountBySerie[a.serieId]++;
      _owned.add(a.lKey);
      assert(_ownedCountBySerie[a.serieId] >= 0 &&
          _ownedCountBySerie[a.serieId] <=
              assetsService.config.seriesMap[a.serieId].amiibos.length);
      storageService.setOwned(_owned);
      notifyListeners();
    }
  }

  void toggleAmiiboOwnership(String amiiboId) {
    final AmiiboModel a = assetsService.config.amiibo(amiiboId);

    if (isOwned(amiiboId)) {
      _ownedCountBySerie[a.serieId]--;
      _owned.remove(amiiboId);
    } else {
      _ownedCountBySerie[a.serieId]++;
      _owned.add(amiiboId);
    }
    assert(_ownedCountBySerie[a.serieId] >= 0 &&
        _ownedCountBySerie[a.serieId] <=
            assetsService.config.seriesMap[a.serieId].amiibos.length);

    storageService.setOwned(_owned);
    notifyListeners();
  }

  void reset() {
    _owned.clear();
    _ownedCountBySerie.updateAll((String k, int v) => 0);
    storageService.setOwned(_owned);
    notifyListeners();
  }
}
