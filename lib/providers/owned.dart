import 'dart:collection';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/services/local_storage.dart';

class OwnedProvider with ChangeNotifier {
  OwnedProvider() {
    _owned.addAll(storageService.getOwned());
    for (SerieModel s in assetsService.amiiboLineup.series) {
      _ownedBySerie[s.id] =
          s.amiibo.where((AmiiboModel e) => _owned.contains(e.id)).length;
    }
  }

  final AssetsService assetsService = locator<AssetsService>();
  final LocalStorageService storageService = locator<LocalStorageService>();
  final List<String> _owned = <String>[];
  final Map<String, int> _ownedBySerie = <String, int>{};

  int get ownedCount => _owned.length;

  UnmodifiableListView<String> get ownedAmiiboIds =>
      UnmodifiableListView<String>(_owned);

  bool isOwned(String amiiboId) => _owned.contains(amiiboId);
  bool isMissed(String amiiboId) => _owned.contains(amiiboId) == false;

  int ownedInSerie(SerieModel s) => _ownedBySerie[s.id];

  double percentOwnedInSerie(SerieModel s) {
    return ownedInSerie(s) / s.amiibo.length;
  }

  void setOwned(AmiiboModel a) {
    if (isMissed(a.id)) {
      _ownedBySerie[a.serieId]++;
      _owned.add(a.id);
      assert(_ownedBySerie[a.serieId] >= 0 &&
          _ownedBySerie[a.serieId] <=
              assetsService.amiiboLineup.getSerieById(a.serieId).amiibo.length);
      storageService.setOwned(_owned);
      notifyListeners();
    }
  }

  void toggleAmiiboOwnership(String amiiboId) {
    final AmiiboModel a = assetsService.amiiboLineup.getAmiiboById(amiiboId);

    if (isOwned(amiiboId)) {
      _ownedBySerie[a.serieId]--;
      _owned.remove(amiiboId);
    } else {
      _ownedBySerie[a.serieId]++;
      _owned.add(amiiboId);
    }
    assert(_ownedBySerie[a.serieId] >= 0 &&
        _ownedBySerie[a.serieId] <=
            assetsService.amiiboLineup.getSerieById(a.serieId).amiibo.length);

    storageService.setOwned(_owned);
    notifyListeners();
  }

  void reset() {
    _owned.clear();
    _ownedBySerie.updateAll((String k, int v) => 0);
    storageService.setOwned(_owned);
    notifyListeners();
  }
}
