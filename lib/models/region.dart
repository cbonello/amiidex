import 'package:meta/meta.dart';

const List<String> RegionIds = <String>['NA', 'EU', 'JP'];

const String DefaultRegionId = 'NA';

const Map<String, String> RegionName = <String, String>{
  'EU': 'actionbar-region-europe',
  'JP': 'actionbar-region-japan',
  'NA': 'actionbar-region-north-america',
};

class RegionModel {
  const RegionModel({
    @required this.name,
    @required this.releaseDate,
  });

  factory RegionModel.fromJson(String name, Map<String, dynamic> json) {
    return RegionModel(
      name: name,
      releaseDate: DateTime.parse(json['release_date']),
    );
  }

  final String name;
  final DateTime releaseDate;
}
