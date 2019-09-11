import 'dart:collection';

import 'package:flutter/material.dart';

class ValuePackModel {
  ValuePackModel.fromJson(String serieId, Map<String, dynamic> json)
      : assert(json['lkey'] != null),
        assert(json['box'] != null),
        assert(json['amiibo'] != null),
        assert(json['barcodes'] != null) {
    _lKey = json['lkey'];
    _box = json['box'];
    _serieId = serieId;
    _amiibo = json['amiibo'].cast<String>();
    assert(_amiibo.isNotEmpty);
    _barcodes = json['barcodes'].cast<String>();
    assert(_barcodes.isNotEmpty);
  }

  String _lKey, _box, _serieId;
  List<String> _amiibo = <String>[];
  List<String> _barcodes = <String>[];

  String get lKey => _lKey;
  Image get box => Image.asset(_box);
  String get serieId => _serieId;

  UnmodifiableListView<String> get amiibos =>
      UnmodifiableListView<String>(_amiibo);

  UnmodifiableListView<String> get barcodes =>
      UnmodifiableListView<String>(_barcodes);

  bool matchBarcode(String barcode) {
    return _barcodes.contains(barcode);
  }
}
