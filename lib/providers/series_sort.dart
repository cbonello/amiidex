import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/serie_list.dart';
import 'package:amiidex/services/local_storage.dart';

class SeriesSortProvider with ChangeNotifier {
  SeriesSortProvider() {
    _order = storageService.getSeriesSort();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  SeriesSortOrder _order;

  SeriesSortOrder get order => _order;

  void toggleSortOrder() {
    _order = _order == SeriesSortOrder.name_ascending
        ? SeriesSortOrder.name_descending
        : SeriesSortOrder.name_ascending;
    storageService.setSeriesSort(_order);
    notifyListeners();
  }
}
