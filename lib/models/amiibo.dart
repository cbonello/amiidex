import 'dart:collection';
import 'dart:typed_data';

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
        assert(
          json['display_amiibo'] != null && json['display_amiibo'] is bool,
        ),
        assert(json['releases'] != null && json['releases'] is Map),
        assert(json['barcodes'] != null),
        assert(json['nfc'] != null &&
            json['nfc'] is String &&
            (json['nfc'].length == 0 || json['nfc'].length == 16)) {
    _lKey = json['lkey'];
    _image = Image.asset(json['image']);
    _displayAmiibo = json['display_amiibo'];
    _box = json['box'];
    _serieID = serieID;
    _url = json['url'];
    json['releases'].forEach((String regionID, dynamic release) {
      assert(regions.containsKey(regionID));
      final ReleaseModel r = ReleaseModel.fromJson(release);
      _releases[regionID] = r;
    });
    _barcodes = json['barcodes'].cast<String>();
    for (int i = 0; i < json['nfc'].length / 2; i++) {
      final String s = json['nfc'].substring(2 * i, 2 * i + 2);
      final int value = int.parse(s, radix: 16);
      _nfc[i] = value;
    }
  }

  String _lKey, _box, _serieID, _url;
  Image _image;
  final Map<String, ReleaseModel> _releases = <String, ReleaseModel>{};
  List<String> _barcodes;
  final Uint8List _nfc = Uint8List(8);
  bool _displayAmiibo;

  String get lKey => _lKey;
  Image get image => _image;
  // Not used frequently so not cached by default.
  bool get boxExists => _box != null;
  Image get box => Image.asset(_box);
  String get serieID => _serieID;
  String get url => _url;
  // If the box and amiibo are the same, which is true for the Delicious Amiibo,
  // we will only display the box in the amiibo detail page.
  bool get displayAmiibo => _displayAmiibo;

  UnmodifiableMapView<String, ReleaseModel> get releases =>
      UnmodifiableMapView<String, ReleaseModel>(_releases);

  bool wasReleasedInRegion(String regionID) => _releases.containsKey(regionID);

  DateTime releaseDate(String regionID) {
    assert(wasReleasedInRegion(regionID));
    return _releases[regionID].releaseDate;
  }

  UnmodifiableListView<String> get barcodes => UnmodifiableListView<String>(_barcodes);

  bool matchBarcode(String barcode) {
    return _barcodes.contains(barcode);
  }

  @override
  String toString() {
    return lKey;
  }
}
