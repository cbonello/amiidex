import 'dart:convert';
import 'dart:io';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/config.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/models/value_pack.dart';
import 'package:flutter_test/flutter_test.dart';

const String CONFIG = 'assets/json/config.json';

void main() {
  test('Amiibo database should load without error', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);
    expect(config.amiibos, isNotEmpty);
  });

  test('Amiibo database should not contain barcode duplicates', () async {
    final File file = File(CONFIG);
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final ConfigModel config = ConfigModel.fromJson(json);
    final List<String> allBarcodes = <String>[];

    for (SerieModel s in config.seriesMap.values) {
      for (AmiiboModel a in s.amiibos) {
        for (String b in a.barcodes) {
          // New releases may be added to the database before they are assigned
          // a barcode.
          if (b.isNotEmpty) {
            expect(allBarcodes.contains(b), isFalse);
            allBarcodes.add(b);
          }
        }
      }
      for (ValuePackModel v in s.valuePacks) {
        for (String b in v.barcodes) {
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

    for (SerieModel s in config.seriesMap.values) {
      for (ValuePackModel v in s.valuePacks) {
        for (String a in v.amiibos) {
          expect(() => config.amiibo(a), returnsNormally);
        }
      }
    }
  });
}
