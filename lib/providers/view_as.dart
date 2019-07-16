import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';

enum DisplayType {
  list,
  grid_small,
  grid_large,
}

enum ItemsDisplayed {
  series,
  amiibo,
  searches,
  missing,
  owned,
}

class ViewAsProvider with ChangeNotifier {
  ViewAsProvider(this.itemsLabel) {
    _viewAs = storageService.getViewAs(itemsLabel);
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  final ItemsDisplayed itemsLabel;
  DisplayType _viewAs;

  DisplayType get viewAs => _viewAs;

  set viewAs(DisplayType type) {
    _viewAs = type;
    storageService.setViewAs(itemsLabel, _viewAs);
    notifyListeners();
  }
}
