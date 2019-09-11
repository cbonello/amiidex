import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';

enum SeriesSortOrder {
  name_ascending,
  name_descending,
}

// Sort options to display series.
class SeriesSortProvider with ChangeNotifier {
  SeriesSortProvider() {
    _order = storageService.getSeriesSort();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  SeriesSortOrder _order;

  SeriesSortOrder get order => _order;

  void toggleSortOrder() {
    if (_order == SeriesSortOrder.name_ascending) {
      _order = SeriesSortOrder.name_descending;
    } else {
      _order = SeriesSortOrder.name_ascending;
    }
    storageService.setSeriesSort(_order);
    notifyListeners();
  }
}
