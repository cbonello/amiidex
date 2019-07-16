import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:amiidex/models/lineup.dart';

class AssetsService {
  static AssetsService _instance;

  static Future<AssetsService> getInstance() async {
    if (_instance == null) {
      _instance = AssetsService();
      _instance.amiiboLineup = await _instance._loadAmiiboLineup();
    }
    return _instance;
  }

  Future<LineupModel> _loadAmiiboLineup() async {
    final String jsonString =
        await rootBundle.loadString('assets/json/lineup.json');
    final Map<String, dynamic> jsonResponse = json.decode(jsonString);
    final LineupModel lineup = LineupModel.fromJson(jsonResponse);
    return lineup;
  }

  LineupModel amiiboLineup;
}
