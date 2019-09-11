import 'dart:collection';

import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/release.dart';
import 'package:flutter/material.dart';

class AmiiboModel {
  AmiiboModel.fromJson(
    UnmodifiableMapView<String, RegionModel> regions,
    String serieId,
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
    _serieId = serieId;
    _url = json['url'];
    json['releases'].forEach((String regionId, dynamic release) {
      assert(regions.containsKey(regionId));
      final ReleaseModel r = ReleaseModel.fromJson(release);
      _releases[regionId] = r;
    });
    _barcodes = json['barcodes'].cast<String>();
  }

  String _lKey, _box, _serieId, _url;
  Image _image;
  final Map<String, ReleaseModel> _releases = <String, ReleaseModel>{};
  List<String> _barcodes;

  String get lKey => _lKey;
  Image get image => _image;
  // Not used frequently so not cached by default.
  Image get box => Image.asset(_box);
  String get serieId => _serieId;
  String get url => _url;

  UnmodifiableMapView<String, ReleaseModel> get releases =>
      UnmodifiableMapView<String, ReleaseModel>(_releases);

  bool wasReleasedInRegion(String regionId) => _releases.containsKey(regionId);

  DateTime releaseDate(String regionId) {
    assert(wasReleasedInRegion(regionId));
    return _releases[regionId].releaseDate;
  }

  UnmodifiableListView<String> get barcodes =>
      UnmodifiableListView<String>(_barcodes);

  bool matchBarcode(String barcode) {
    return _barcodes.contains(barcode);
  }
}
