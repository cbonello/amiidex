import 'dart:collection';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/value_pack.dart';
import 'package:flutter/material.dart';

class AmiiboBoxModel {
  // A box with only one amiibo.
  AmiiboBoxModel.fromAmiibo(AmiiboModel amiibo) : assert(amiibo != null) {
    _lKey = amiibo.lKey;
    _box = amiibo.box;
    _amiibo = <AmiiboModel>[amiibo];
  }

  // A Value-pack box.
  AmiiboBoxModel.fromValuePack(
    ValuePackModel valuePack,
    List<AmiiboModel> amiibo,
  )   : assert(valuePack != null),
        assert(amiibo != null) {
    _lKey = valuePack.lKey;
    _box = valuePack.box;
    _amiibo = amiibo;
  }

  String _lKey;
  Image _box;
  List<AmiiboModel> _amiibo;

  String get lKey => _lKey;
  Image get box => _box;

  UnmodifiableListView<AmiiboModel> get amiibos =>
      UnmodifiableListView<AmiiboModel>(_amiibo);
}
