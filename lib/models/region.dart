import 'package:amiidex/UI/widgets/flag.dart';
import 'package:flutter/material.dart';
import 'package:meta/meta.dart';

// TODO(cbonello): Use enum.
const List<String> RegionIds = <String>['AMER', 'APAC', 'EMEA'];

const String DefaultRegionId = 'AMER';

const Map<String, String> RegionName = <String, String>{
  'AMER': 'actionbar-region-north-america',
  'APAC': 'actionbar-region-japan',
  'EMEA': 'actionbar-region-europe',
};

class RegionModel {
  const RegionModel({
    @required this.id,
    @required this.releaseDate,
  });

  factory RegionModel.fromJson(String id, Map<String, dynamic> json) {
    assert(json['release_date'] != null);

    return RegionModel(
      id: id,
      releaseDate: DateTime.parse(json['release_date']),
    );
  }

  final String id;
  final DateTime releaseDate;

  Widget get flag => Flag(region: id);
}
