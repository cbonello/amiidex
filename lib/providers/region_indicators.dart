import 'package:amiidex/models/country.dart';
import 'package:amiidex/services/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:flutter/material.dart';

// Manage the country flags dislayed for each region (AMER, APAC and EMEA).
class RegionIndicatorsProvider with ChangeNotifier {
  void init() {
    for (String regionId in assetsService.config.regions.keys) {
      _indicators[regionId] = storageService.getRegionIndicator(
        regionId,
        assetsService.config.region(regionId).defaultCountry,
      );
    }
  }

  final AssetsService assetsService = locator<AssetsService>();
  final LocalStorageService storageService = locator<LocalStorageService>();

  // Region -> Country.
  final Map<String, String> _indicators = <String, String>{};

  Map<String, String> get indicators => _indicators;

  CountryModel country(String regionId) {
    assert(_indicators.containsKey(regionId));
    final String countryId = _indicators[regionId];
    assert(assetsService.config.countries.containsKey(countryId));
    return assetsService.config.countries[countryId];
  }

  Image flag(String regionId) {
    return country(regionId).flag;
  }

  void indicator(String regionId, String countryId) {
    assert(_indicators.containsKey(regionId));
    _indicators[regionId] = countryId;
    storageService.setRegionIndicator(regionId, countryId);
    notifyListeners();
  }
}
