import 'dart:convert';

import 'package:amiidex/models/config.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class AssetsService {
  static AssetsService _instance;

  static Future<AssetsService> getInstance() async {
    _instance ??= AssetsService();
    return _instance;
  }

  ConfigModel _config;

  ConfigModel get config => _config;

  set config(ConfigModel cfg) {
    assert(_config == null);
    _config = cfg;
  }
}

Future<ConfigModel> loadConfig() async {
  final ConfigModel config = await compute<String, ConfigModel>(
    _decodeConfig,
    await rootBundle.loadString('assets/json/config.json'),
    debugLabel: 'load config',
  );
  return config;
}

Future<ConfigModel> _decodeConfig(String jsonString) async {
  final Map<String, dynamic> jsonResponse = json.decode(jsonString);
  return ConfigModel.fromJson(jsonResponse);
}
