import 'dart:collection';

import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/release.dart';
import 'package:flutter/material.dart';

class AmiiboModel {
  AmiiboModel.fromJson(
    UnmodifiableMapView<String, RegionModel> regions,
    String serieID,
    Map<String, dynamic> json,
  )   : assert(json['lkey'] != null && json['lkey'] is String),
        assert(json['image'] != null && json['image'] is String),
        assert(json['box'] != null && json['box'] is String),
        assert(json['url'] != null && json['url'] is String),
        assert(json['releases'] != null && json['releases'] is Map),
        assert(json['barcodes'] != null) {
    _lKey = json['lkey'];
    _image = Image.asset(json['image']);
    _box = json['box'];
    _serieID = serieID;
    _url = json['url'];
    json['releases'].forEach((String regionID, dynamic release) {
      assert(regions.containsKey(regionID));
      final ReleaseModel r = ReleaseModel.fromJson(release);
      _releases[regionID] = r;
    });
    _barcodes = json['barcodes'].cast<String>();
  }

  String _lKey, _box, _serieID, _url;
  Image _image;
  final Map<String, ReleaseModel> _releases = <String, ReleaseModel>{};
  List<String> _barcodes;

  String get lKey => _lKey;
  Image get image => _image;
  // Not used frequently so not cached by default.
  Image get box => Image.asset(_box);
  String get serieID => _serieID;
  String get url => _url;

  UnmodifiableMapView<String, ReleaseModel> get releases =>
      UnmodifiableMapView<String, ReleaseModel>(_releases);

  bool wasReleasedInRegion(String regionID) => _releases.containsKey(regionID);

  DateTime releaseDate(String regionID) {
    assert(wasReleasedInRegion(regionID));
    return _releases[regionID].releaseDate;
  }

  UnmodifiableListView<String> get barcodes =>
      UnmodifiableListView<String>(_barcodes);

  bool matchBarcode(String barcode) {
    return _barcodes.contains(barcode);
  }

  @override
  String toString() {
    return lKey;
  }
}
