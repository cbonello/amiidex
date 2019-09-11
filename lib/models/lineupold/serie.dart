// import 'package:amiidex/models/lineup/amiibo.dart';
// import 'package:amiidex/models/lineup/amiibo_box.dart';
// import 'package:amiidex/models/lineup/amiibo_list.dart';
// import 'package:amiidex/models/lineup/value_pack.dart';
// import 'package:amiidex/models/lineup/value_pack_list.dart';
// import 'package:flutter/material.dart';

// class SerieModel {
//   const SerieModel(
//     this.id,
//     this.header,
//     this.logo,
//     this._amiibo,
//     this._valuePacks,
//   );

//   factory SerieModel.fromJson(Map<String, dynamic> json) {
//     assert(json['id'] != null);
//     assert(json['header'] != null);
//     assert(json['logo'] != null);
//     assert(json['amiibo'] != null);

//     final AmiiboList amiibo = AmiiboList.fromJson(json['id'], json['amiibo']);
//     final ValuePackList valuePacks = json['value_packs'] != null
//         ? ValuePackList.fromJson(json['id'], json['value_packs'])
//         : ValuePackList();

//     final SerieModel serie = SerieModel(
//       json['id'],
//       Image.asset(json['header'], fit: BoxFit.cover),
//       Image.asset(json['logo']),
//       amiibo,
//       valuePacks,
//     );

//     return serie;
//   }

//   final String id;
//   final Image header, logo;
//   final AmiiboList _amiibo;
//   final ValuePackList _valuePacks;

//   AmiiboList get amiibo => AmiiboList.from(_amiibo);

//   ValuePackList get valuePacks => ValuePackList.from(_valuePacks);

//   AmiiboBoxModel matchBarcode(String barcode) {
//     for (AmiiboModel a in _amiibo) {
//       if (a.matchBarcode(barcode)) {
//         return AmiiboBoxModel.fromAmiibo(a);
//       }
//     }
//     for (ValuePackModel v in _valuePacks) {
//       if (v.matchBarcode(barcode)) {
//         return AmiiboBoxModel.fromValuePack(
//           v,
//           v.amiibo.map<AmiiboModel>((String id) => _amiibo.getAmiiboById(id)),
//         );
//       }
//     }
//     return null;
//   }
// }
