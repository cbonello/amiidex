import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/models/region.dart';

class AmiiboModel {
  const AmiiboModel(
    this.id,
    this.image,
    this.box,
    this.serieId,
    this.url,
    this._regions,
    this.barcodes,
  );

  factory AmiiboModel.fromJson(String serieId, Map<String, dynamic> json) {
    assert(json['id'] != null);
    assert(json['image'] != null);
    assert(json['box'] != null);
    assert(json['url'] != null);
    assert(json['regions'] != null);
    assert(json['barcodes'] != null);

    return AmiiboModel(
      json['id'],
      Image.asset(json['image']),
      Image.asset(json['box']),
      serieId,
      json['url'],
      RegionsModel.fromJson(json['regions']),
      json['barcodes'].cast<String>(),
    );
  }

  final String id;
  final Image image, box;
  final String serieId, url;
  final RegionsModel _regions;
  final List<String> barcodes;

  bool matchBarcode(String barcode) {
    for (String b in barcodes) {
      if (b == barcode) {
        return true;
      }
    }
    return false;
  }

  RegionModel region(String regionId) {
    return _regions.region(regionId);
  }

  bool wasReleasedInRegion(String regionId) =>
      _regions.regions.containsKey(regionId);
  DateTime releaseDate(String regionId) {
    assert(_regions.regions.containsKey(regionId));
    return _regions.regions[regionId].releaseDate;
  }

  UnmodifiableMapView<String, RegionModel> get regions => _regions.regions;
}
