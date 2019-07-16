import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/services/local_storage.dart';

class RegionProvider with ChangeNotifier {
  RegionProvider() {
    _region = storageService.getRegion();
    if (RegionName.keys.contains(_region) == false) {
      _region = DefaultRegion;
    }
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  String _region;

  String get regionId => _region;
  String get regionName => RegionName[_region];

  set regionId(String regionId) {
    assert(RegionType.contains(regionId));
    _region = regionId;
    storageService.setRegion(_region);
    notifyListeners();
  }
}
