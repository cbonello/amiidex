import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/services/local_storage.dart';

class AmiiboSortProvider with ChangeNotifier {
  AmiiboSortProvider() {
    _order = storageService.getAmiiboSort();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  AmiiboSortOrder _order;

  AmiiboSortOrder get order => _order;

  set order(AmiiboSortOrder order) {
    _order = order;
    storageService.setAmiiboSort(_order);
    notifyListeners();
  }
}
