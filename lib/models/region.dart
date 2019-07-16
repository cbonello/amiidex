import 'dart:collection';

import 'package:meta/meta.dart';

const List<String> RegionType = <String>['NA', 'EU', 'JP'];

const String DefaultRegion = 'NA';

const Map<String, String> RegionName = <String, String>{
  'EU': 'actionbar-region-europe',
  'JP': 'actionbar-region-japan',
  'NA': 'actionbar-region-north-america',
};

class RegionModel {
  const RegionModel({
    @required this.name,
    @required this.releaseDate,
  });

  factory RegionModel.fromJson(String name, Map<String, dynamic> json) {
    return RegionModel(
      name: name,
      releaseDate: DateTime.parse(json['release_date']),
    );
  }

  final String name;
  final DateTime releaseDate;
}

class RegionsModel {
  RegionsModel(this._regions);

  factory RegionsModel.fromJson(Map<String, dynamic> json) {
    final Map<String, RegionModel> regions = <String, RegionModel>{};
    for (String r in RegionName.keys) {
      if (json[r] != null) {
        regions[r] = RegionModel.fromJson(RegionName[r], json[r]);
      }
    }

    return RegionsModel(regions);
  }

  final Map<String, RegionModel> _regions;

  UnmodifiableMapView<String, RegionModel> get regions =>
      UnmodifiableMapView<String, RegionModel>(_regions);

  bool isDefined(String regionId) {
    return region(regionId) != null;
  }

  RegionModel region(String regionId) {
    return regions.containsKey(regionId) ? regions[regionId] : null;
  }
}
