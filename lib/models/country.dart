import 'package:amiidex/UI/widgets/Flag.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:flutter/material.dart';

class CountryModel {
  CountryModel.fromJson(String regionID, Map<String, dynamic> json)
      : assert(json['lkey'] != null),
        assert(json['flag'] != null) {
    _lKey = json['lkey'];
    _regionID = regionID;
    _url = json['url'];
    _flagAsset = json['flag'];
  }

  String _lKey, _regionID, _url, _flagAsset;

  String get lKey => _lKey;
  String get regionID => _regionID;
  String get url => _url;
  bool get hasURL => _url != null;

  // Not used frequently so not cached by default.
  Flag flag(Function() onTap) => Flag(asset: _flagAsset, onTap: onTap);

  // Flag + country name.
  Widget label(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Padding(
          padding: const EdgeInsets.only(right: 3.0),
          child: Flag(asset: _flagAsset, height: 20.0, width: 34),
        ),
        Expanded(
          child: Text(I18n.of(context).text(lKey)),
        ),
      ],
    );
  }
}
