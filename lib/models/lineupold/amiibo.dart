// import 'package:amiidex/models/lineup/release_data.dart';
// import 'package:amiidex/models/lineup/release_region_list.dart';
// import 'package:amiidex/util/region.dart';
// import 'package:collection/collection.dart';
// import 'package:flutter/material.dart';

// class AmiiboModel {
//   const AmiiboModel(
//     this.id,
//     this.image,
//     this.box,
//     this.serieId,
//     this.url,
//     this._releaseRegions,
//     this._barcodes,
//   );

//   factory AmiiboModel.fromJson(String serieId, Map<String, dynamic> json) {
//     assert(json['id'] != null);
//     assert(json['image'] != null);
//     assert(json['box'] != null);
//     assert(json['url'] != null);
//     assert(json['release_regions'] != null);
//     assert(json['barcodes'] != null);

//     return AmiiboModel(
//       json['id'],
//       Image.asset(json['image']),
//       Image.asset(json['box']),
//       serieId,
//       json['url'],
//       ReleaseRegionList.fromJson(json['release_regions']),
//       json['barcodes'].cast<String>(),
//     );
//   }

//   final String id;
//   final Image image, box;
//   final String serieId, url;
//   final ReleaseRegionList _releaseRegions;
//   final List<String> _barcodes;

//   bool matchBarcode(String barcode) {
//     for (String b in _barcodes) {
//       if (b == barcode) {
//         return true;
//       }
//     }
//     return false;
//   }

//   UnmodifiableMapView<RegionId, ReleaseDataModel> get releaseRegions =>
//       _releaseRegions.regions;

//   ReleaseDataModel releaseRegion(RegionId regionId) {
//     return _releaseRegions.region(regionId);
//   }

//   bool wasReleasedInRegion(RegionId regionId) =>
//       _releaseRegions.regions.containsKey(regionId);

//   DateTime releaseDate(RegionId regionId) {
//     assert(_releaseRegions.regions.containsKey(regionId));
//     return _releaseRegions.regions[regionId].releaseDate;
//   }

//   UnmodifiableListView<String> get barcodes =>
//       UnmodifiableListView<String>(_barcodes);
// }
