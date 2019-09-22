import 'dart:convert';
import 'dart:io';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/models/country.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/models/value_pack.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;

const String CONFIG = 'assets/json/config.json';

void main() {
  test('Amiibo database should load without error', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);
    expect(config.amiibos, isNotEmpty);
  });

  test('Default country in a region should be valid', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);

    for (final RegionModel r in config.regions.values) {
      final List<String> allCountries = r.countries
          .map<String>(
            (CountryModel c) => c.lKey,
          )
          .toList();
      expect(allCountries.contains(r.defaultCountry), isTrue);
    }
  });

  test('Countries URL should be valid', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);

    for (final RegionModel r in config.regions.values) {
      for (final CountryModel c in r.countries) {
        if (c.url != null) {
          final http.Response response = await http.head(c.url);
          expect(response.statusCode, 200);
        }
      }
    }
  });

  test('Countries URL should not have duplicates', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);

    for (final RegionModel r in config.regions.values) {
      final List<String> allURLs = <String>[];
      for (final CountryModel c in r.countries) {
        if (c.url != null) {
          expect(allURLs.contains(c.lKey), isFalse);
          allURLs.add(c.lKey);
        }
      }
    }
  });

  // test('Countries flag should point to a valid image asset', () async {
  //   final File file = File(CONFIG);
  //   final Map<String, dynamic> json = jsonDecode(await file.readAsString());
  //   final ConfigModel config = ConfigModel.fromJson(json);

  //   for (final RegionModel r in config.regions.values) {
  //     // final List<String> allURLs = <String>[];
  //     for (final CountryModel c in r.countries) {
  //       print(c.lKey);
  //       final Image img = Image.asset(c.flagAsset);
  //       print(img);
  //       // expect(allURLs.contains(c.lKey), isFalse);
  //     }
  //   }
  // });

  test('Amiibo database should not contain country duplicates', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);
    final List<String> allRegions = <String>[];

    for (final RegionModel r in config.regions.values) {
      for (final CountryModel c in r.countries) {
        expect(allRegions.contains(c.lKey), isFalse);
        allRegions.add(c.lKey);
      }
    }
  });

  test('Amiibo database should not contain barcode duplicates', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);
    final List<String> allBarcodes = <String>[];

    for (final SerieModel s in config.seriesMap.values) {
      for (final AmiiboModel a in s.amiibos) {
        for (final String b in a.barcodes) {
          // New releases may be added to the database before they are assigned
          // a barcode.
          if (b.isNotEmpty) {
            expect(allBarcodes.contains(b), isFalse);
            allBarcodes.add(b);
          }
        }
      }
      for (final ValuePackModel v in s.valuePacks) {
        for (final String b in v.barcodes) {
          if (b.isNotEmpty) {
            expect(allBarcodes.contains(b), isFalse);
            allBarcodes.add(b);
          }
        }
      }
    }
  });

  test('Value packs should record valid amiibo IDs', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);

    for (final SerieModel s in config.seriesMap.values) {
      for (final ValuePackModel v in s.valuePacks) {
        for (final String a in v.amiibos) {
          expect(() => config.amiibo(a), returnsNormally);
        }
      }
    }
  });
}
