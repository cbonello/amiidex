// import 'package:amiidex/models/lineup/amiibo.dart';
// import 'package:amiidex/models/lineup/amiibo_list.dart';
// import 'package:amiidex/models/lineup/value_pack.dart';
// import 'package:flutter/material.dart';

// class AmiiboBoxModel {
//   const AmiiboBoxModel(
//     this.id,
//     this.box,
//     this.amiibo,
//   );

//   factory AmiiboBoxModel.fromAmiibo(AmiiboModel a) {
//     return AmiiboBoxModel(
//       a.id,
//       a.box,
//       AmiiboList.from(<AmiiboModel>[a]),
//     );
//   }

//   factory AmiiboBoxModel.fromValuePack(
//     ValuePackModel v,
//     Iterable<AmiiboModel> l,
//   ) {
//     return AmiiboBoxModel(v.id, v.box, AmiiboList.from(l));
//   }

//   final String id;
//   final Image box;
//   final AmiiboList amiibo;
// }
