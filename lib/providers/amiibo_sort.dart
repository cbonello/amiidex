import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:flutter/material.dart';

enum AmiiboSortOrder {
  name_ascending,
  name_descending,
  release_date_ascending,
  release_date_descending,
}

// Sort options to display amiibo.
class AmiiboSortProvider with ChangeNotifier {
  AmiiboSortProvider() {
    _order = storageService.getAmiiboSort();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  AmiiboSortOrder _order;

  AmiiboSortOrder get order => _order;

  void setOrder(BuildContext context, AmiiboSortOrder order) {
    _order = order;
    storageService.setAmiiboSort(_order);
    notifyListeners();
  }
}
