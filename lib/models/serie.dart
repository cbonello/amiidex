import 'dart:collection';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_box.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/value_pack.dart';
import 'package:flutter/material.dart';

class SerieModel {
  SerieModel.fromJson(UnmodifiableMapView<String, RegionModel> regions,
      Map<String, dynamic> json)
      : assert(json['lkey'] != null),
        assert(json['header'] != null),
        assert(json['logo'] != null),
        assert(json['amiibo'] != null) {
    _lKey = json['lkey'];
    _header = Image.asset(json['header'], fit: BoxFit.cover);
    _logo = Image.asset(json['logo']);
    json['amiibo'].forEach((dynamic amiibo) {
      final AmiiboModel a = AmiiboModel.fromJson(regions, _lKey, amiibo);
      _amiibo.add(a);
    });
    final List<String> valuePackIds = <String>[];
    if (json['value_packs'] != null) {
      json['value_packs'].forEach((dynamic valuePack) {
        final ValuePackModel v = ValuePackModel.fromJson(_lKey, valuePack);
        assert(valuePackIds.contains(v) == false);
        _valuePacks.add(v);
      });
    }
  }

  String _lKey;
  Image _header, _logo;
  final List<AmiiboModel> _amiibo = <AmiiboModel>[];
  final List<ValuePackModel> _valuePacks = <ValuePackModel>[];

  String get lKey => _lKey;
  Image get header => _header;
  Image get logo => _logo;

  List<AmiiboModel> get amiiboList => List<AmiiboModel>.from(_amiibo.toList());

  UnmodifiableListView<AmiiboModel> get amiibos =>
      UnmodifiableListView<AmiiboModel>(_amiibo);

  AmiiboModel amiibo(String id) {
    final int idx = _amiibo.indexWhere((AmiiboModel a) => a.lKey == id);
    assert(idx != -1);
    return _amiibo[idx];
  }

  UnmodifiableListView<ValuePackModel> get valuePacks =>
      UnmodifiableListView<ValuePackModel>(_valuePacks);

  AmiiboBoxModel matchBarcode(String barcode) {
    for (AmiiboModel a in _amiibo) {
      if (a.matchBarcode(barcode)) {
        return AmiiboBoxModel.fromAmiibo(a);
      }
    }
    for (ValuePackModel v in _valuePacks) {
      if (v.matchBarcode(barcode)) {
        return AmiiboBoxModel.fromValuePack(
          v,
          // We assume that value-packs only contain amiibo from the same serie,
          // which is true so far.
          v.amiibos
              .map<AmiiboModel>((String amiiboId) => amiibo(amiiboId))
              .toList(),
        );
      }
    }
    return null;
  }
}
