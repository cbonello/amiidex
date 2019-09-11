import 'dart:collection';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_box.dart';
import 'package:amiidex/models/country.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/serie.dart';

class ConfigModel {
  ConfigModel.fromJson(Map<String, dynamic> json)
      : assert(json['regions'] != null),
        assert(json['lineup'] != null) {
    json['regions'].forEach((dynamic region) {
      final RegionModel r = RegionModel.fromJson(region);
      assert(_regions.containsKey(r.lKey) == false);
      _regions[r.lKey] = r;
      for (CountryModel country in r.countries) {
        assert(_countries.containsKey(country.lKey) == false);
        _countries[country.lKey] = country;
      }
    });
    assert(_regions.length > 1);
    json['lineup'].forEach((dynamic serie) {
      final SerieModel s = SerieModel.fromJson(regions, serie);
      assert(_series.containsKey(s.lKey) == false);
      _series[s.lKey] = s;
      for (AmiiboModel a in s.amiibos) {
        _amiibo[a.lKey] = a;
      }
    });
    assert(_series.length > 1);
  }

  // Regions/ Countries.
  final Map<String, RegionModel> _regions = <String, RegionModel>{};
  final Map<String, CountryModel> _countries = <String, CountryModel>{};

  UnmodifiableMapView<String, RegionModel> get regions =>
      UnmodifiableMapView<String, RegionModel>(_regions);

  RegionModel region(String regionId) {
    assert(_regions.containsKey(regionId));
    return _regions[regionId];
  }

  RegionModel get defaultRegion => _regions.values.first;

  UnmodifiableMapView<String, CountryModel> get countries =>
      UnmodifiableMapView<String, CountryModel>(_countries);

  CountryModel country(String countryId) {
    assert(_countries.containsKey(countryId));
    return _countries[countryId];
  }

  UnmodifiableListView<CountryModel> countriesInRegion(String regionId) {
    assert(_regions.containsKey(regionId));
    return region(regionId).countries;
  }

  CountryModel defaultCountryInRegion(String regionId) {
    assert(_regions.containsKey(regionId));
    final String countryId = region(regionId).defaultCountry;
    assert(_countries.containsKey(countryId));
    return _countries[countryId];
  }

  AmiiboBoxModel matchBarcode(String barcode) {
    for (SerieModel serie in _series.values) {
      final AmiiboBoxModel match = serie.matchBarcode(barcode);
      if (match != null) {
        return match;
      }
    }
    return null;
  }

  // Series/ Amiibo.
  final Map<String, SerieModel> _series = <String, SerieModel>{};
  final Map<String, AmiiboModel> _amiibo = <String, AmiiboModel>{};

  List<SerieModel> get serieList =>
      List<SerieModel>.from(_series.values.toList());

  // TOO(bonello): not required.
  UnmodifiableMapView<String, SerieModel> get seriesMap =>
      UnmodifiableMapView<String, SerieModel>(_series);

  SerieModel serie(String serieId) {
    assert(_series.containsKey(serieId));
    return _series[serieId];
  }

  List<AmiiboModel> get amiiboList =>
      List<AmiiboModel>.from(_amiibo.values.toList());

  UnmodifiableMapView<String, AmiiboModel> get amiibos =>
      UnmodifiableMapView<String, AmiiboModel>(_amiibo);

  AmiiboModel amiibo(String amiiboId) {
    assert(_amiibo.containsKey(amiiboId));
    return _amiibo[amiiboId];
  }

  UnmodifiableListView<AmiiboModel> amiiboInSerie(String serieId) {
    assert(_series.containsKey(serieId));
    return serie(serieId).amiibos;
  }
}
