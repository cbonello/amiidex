import 'package:flutter/material.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_list.dart';

class SerieModel {
  const SerieModel(
    this.id,
    this.header,
    this.logo,
    this._amiibo,
  );

  factory SerieModel.fromJson(Map<String, dynamic> json) {
    assert(json['id'] != null);
    assert(json['header'] != null);
    assert(json['logo'] != null);
    assert(json['amiibo'] != null);

    final AmiiboList amiibo = AmiiboList.fromJson(json['id'], json['amiibo']);
    final SerieModel serie = SerieModel(
      json['id'],
      json['header'],
      Image.asset(json['logo']),
      amiibo,
    );

    return serie;
  }

  final String id;
  final String header;
  final Image logo;
  final AmiiboList _amiibo;

  AmiiboList get amiibo => AmiiboList.from(_amiibo);

  AmiiboModel matchBarcode(String barcode) {
    for (AmiiboModel a in _amiibo) {
      if (a.matchBarcode(barcode)) {
        return a;
      }
    }
    return null;
  }
}
