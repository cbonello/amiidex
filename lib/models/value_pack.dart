import 'dart:collection';

import 'package:flutter/material.dart';

class ValuePackModel {
  const ValuePackModel(
    this.id,
    this.box,
    this.serieId,
    this._amiibo,
    this._barcodes,
  );

  factory ValuePackModel.fromJson(String serieId, Map<String, dynamic> json) {
    assert(json['id'] != null);
    assert(json['box'] != null);
    assert(json['amiibo'] != null);
    assert(json['barcodes'] != null);

    return ValuePackModel(
      json['id'],
      Image.asset(json['box']),
      serieId,
      json['amiibo'].cast<String>(),
      json['barcodes'].cast<String>(),
    );
  }

  final String id;
  final Image box;
  final String serieId;
  final List<String> _barcodes, _amiibo;

  bool matchBarcode(String barcode) {
    for (String b in _barcodes) {
      if (b == barcode) {
        return true;
      }
    }
    return false;
  }

  UnmodifiableListView<String> get barcodes =>
      UnmodifiableListView<String>(_barcodes);

  UnmodifiableListView<String> get amiibo =>
      UnmodifiableListView<String>(_amiibo);
}
