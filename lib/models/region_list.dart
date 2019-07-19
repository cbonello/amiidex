import 'dart:collection';

import 'package:amiidex/models/region.dart';

class RegionsList {
  RegionsList(this._list);

  factory RegionsList.fromJson(Map<String, dynamic> json) {
    final Map<String, RegionModel> regions = <String, RegionModel>{};
    for (String r in json.keys) {
      assert(RegionIds.contains(r));
      regions[r] = RegionModel.fromJson(RegionName[r], json[r]);
    }
    assert(regions.isNotEmpty);

    return RegionsList(regions);
  }

  final Map<String, RegionModel> _list;

  UnmodifiableMapView<String, RegionModel> get regions =>
      UnmodifiableMapView<String, RegionModel>(_list);

  bool isDefined(String regionId) {
    return region(regionId) != null;
  }

  RegionModel region(String regionId) {
    return regions.containsKey(regionId) ? regions[regionId] : null;
  }
}
