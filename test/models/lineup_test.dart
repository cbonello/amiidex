import 'dart:convert';
import 'dart:io';

import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/lineup.dart';
import 'package:flutter_test/flutter_test.dart';

void main() {
  test('Amiibo database should load without error', () async {
    final File file = File('assets/json/lineup.json');
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final LineupModel lineup = LineupModel.fromJson(json);
    expect(lineup.amiibo, isNotEmpty);
  });

  test('Amiibo database should not contain barcode duplicates', () async {
    final File file = File('assets/json/lineup.json');
    final Map<String, dynamic> json = jsonDecode(await file.readAsString());
    final LineupModel lineup = LineupModel.fromJson(json);
    final List<String> allBarcodes = <String>[];

    for (AmiiboModel a in lineup.amiibo) {
      for (String b in a.barcodes) {
        expect(allBarcodes.contains(b), isFalse);
        allBarcodes.add(b);
      }
    }
  });
}
