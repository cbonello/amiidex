import 'dart:collection';

import 'package:amiidex/models/country.dart';

class RegionModel {
  RegionModel.fromJson(Map<String, dynamic> json)
      : assert(json['lkey'] != null),
        assert(json['lkey_short'] != null),
        assert(json['default_country'] != null),
        assert(json['countries'] != null) {
    _lKey = json['lkey'];
    _lKeyShort = json['lkey_short'];
    _defaultCountry = json['default_country'];
    final Map<String, CountryModel> countries = <String, CountryModel>{};
    json['countries'].forEach((dynamic country) {
      final CountryModel c = CountryModel.fromJson(_lKey, country);
      assert(countries.containsKey(c.lKey) == false);
      countries[c.lKey] = c;
    });
    assert(countries.containsKey(_defaultCountry));
    _countries.addAll(countries.values);
  }

  String _lKey, _lKeyShort;
  String _defaultCountry;
  // To display the list of countries associated with a region in the settings
  // view.
  final List<CountryModel> _countries = <CountryModel>[];

  String get lKey => _lKey;
  String get lKeyShort => _lKeyShort;
  String get defaultCountry => _defaultCountry;

  UnmodifiableListView<CountryModel> get countries =>
      UnmodifiableListView<CountryModel>(_countries);
}
