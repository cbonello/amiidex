import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';

// The region selected when amiibo are displayed by release date.
class SelectedRegionProvider with ChangeNotifier {
  SelectedRegionProvider() {
    // TODO(cbonello): don't use a hardcoded constant.
    _id = storageService.getRegion('region_AMER');
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  String _id;

  String get regionId => _id;

  set regionId(String id) {
    _id = id;
    storageService.setRegion(_id);
    notifyListeners();
  }
}
