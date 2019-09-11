// import 'dart:collection';

// import 'package:amiidex/models/lineup/release_data.dart';
// import 'package:amiidex/util/region.dart';

// class ReleaseRegionList {
//   ReleaseRegionList(this._regions);

//   factory ReleaseRegionList.fromJson(Map<String, dynamic> json) {
//     final Map<RegionId, ReleaseDataModel> regions =
//         <RegionId, ReleaseDataModel>{};
//     for (String s in json.keys) {
//       final ReleaseDataModel model = ReleaseDataModel.fromJson(s, json[s]);
//       regions[model.id] = model;
//     }
//     assert(regions.isNotEmpty);
//     return ReleaseRegionList(regions);
//   }

//   final Map<RegionId, ReleaseDataModel> _regions;

//   UnmodifiableMapView<RegionId, ReleaseDataModel> get regions =>
//       UnmodifiableMapView<RegionId, ReleaseDataModel>(_regions);

//   bool isDefined(RegionId regionId) {
//     return _regions.containsKey(regionId);
//   }

//   ReleaseDataModel region(RegionId regionId) {
//     return _regions[regionId]; // null if key is not present.
//   }
// }
