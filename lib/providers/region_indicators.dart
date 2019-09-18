import 'package:amiidex/models/country.dart';
import 'package:amiidex/services/assets.dart';
import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:flutter/material.dart';

// Manage the country flags dislayed for each region (AMER, APAC and EMEA).
class RegionIndicatorsProvider with ChangeNotifier {
  RegionIndicatorsProvider() {
    // Constraints:
    // 1) Provider must be inserted in the widget tree above MaterialApp to be
    //    accessible to the widgets created by onGenerateRoute().
    // 2) Provider depends on the assets service, which is not available when
    //    the provider is created.
    _providerInitialized = false;
  }

  bool _providerInitialized;
  final AssetsService _assetsService = locator<AssetsService>();
  final LocalStorageService _storageService = locator<LocalStorageService>();

  // Region -> Default country.
  final Map<String, String> _indicators = <String, String>{};

  Map<String, String> get indicators {
    _performInitialization();
    return _indicators;
  }

  CountryModel country(String regionId) {
    _performInitialization();
    assert(_indicators.containsKey(regionId));
    final String countryId = _indicators[regionId];
    assert(_assetsService.config.countries.containsKey(countryId));
    return _assetsService.config.countries[countryId];
  }

  Widget flag(String regionId) {
    _performInitialization();
    return country(regionId).flag(null);
  }

  void indicator(String regionId, String countryId) {
    _performInitialization();
    assert(_indicators.containsKey(regionId));
    _indicators[regionId] = countryId;
    _storageService.setRegionIndicator(regionId, countryId);
    notifyListeners();
  }

  void _performInitialization() {
    if (_providerInitialized == false) {
      for (String regionId in _assetsService.config.regions.keys) {
        _indicators[regionId] = _storageService.getRegionIndicator(
          regionId,
          _assetsService.config.region(regionId).defaultCountry,
        );
      }
      _providerInitialized = true;
    }
  }
}
