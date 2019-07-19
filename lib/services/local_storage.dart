import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/models/region.dart';
import 'package:amiidex/models/serie_list.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  String getPreferredLanguage() {
    return _preferences.getString('preferred_language') ?? 'en_US';
  }

  Future<bool> setPreferredLanguage(String lang) {
    return _preferences.setString('preferred_language', lang);
  }

  String getRegion() {
    return _preferences.getString('region') ?? DefaultRegionId;
  }

  Future<bool> setRegion(String region) {
    return _preferences.setString('region', region);
  }

  LockStatus getLockStatus() {
    final int val = _preferences.getInt('lock_status');

    if (val == null) {
      return LockStatus.opened;
    }
    return LockStatus.values[val];
  }

  Future<bool> setLockStatus(LockStatus status) {
    return _preferences.setInt('lock_status', status.index);
  }

  SeriesSortOrder getSeriesSort() {
    SeriesSortOrder sort;
    try {
      final int v = _preferences.getInt('series_sort') ?? 0;
      sort = SeriesSortOrder.values[v];
    } catch (_) {
      return SeriesSortOrder.name_ascending;
    }
    return sort;
  }

  Future<bool> setSeriesSort(SeriesSortOrder sort) {
    return _preferences.setInt('series_sort', sort.index);
  }

  AmiiboSortOrder getAmiiboSort() {
    AmiiboSortOrder sort;
    try {
      final int v = _preferences.getInt('amiibo_sort') ?? 0;
      sort = AmiiboSortOrder.values[v];
    } catch (_) {
      return AmiiboSortOrder.name_ascending;
    }
    return sort;
  }

  Future<bool> setAmiiboSort(AmiiboSortOrder sort) {
    return _preferences.setInt('amiibo_sort', sort.index);
  }

  DisplayType getViewAs(ItemsDisplayed items) {
    final String label = '$items'.split('.').last; // Enum to string.
    DisplayType type;
    try {
      final int v = _preferences.getInt('${label}_view_as') ?? 0;
      type = DisplayType.values[v];
    } catch (_) {
      return DisplayType.grid_small;
    }
    return type;
  }

  Future<bool> setViewAs(ItemsDisplayed items, DisplayType type) {
    final String label = '$items'.split('.').last;
    return _preferences.setInt('${label}_view_as', type.index);
  }

  List<String> getOwned() {
    List<String> owned;
    try {
      owned = _preferences.getStringList('owned') ?? <String>[];
    } catch (_) {
      return <String>[];
    }
    return owned;
  }

  Future<bool> setOwned(List<String> owned) {
    return _preferences.setStringList('owned', owned);
  }

  // Map<String, List<String>> getOwned() {
  //   final Map<String, List<String>> owned = <String, List<String>>{};
  //   final List<String> encoded =
  //       _preferences.getStringList('owned') ?? <String>[];
  //   if (encoded.isNotEmpty) {
  //     for (String s in encoded) {
  //       final String amiiboId = _deserializeAmiiboId(s);
  //       final List<String> regions = _deserializeRegions(s);
  //       owned[amiiboId] = regions;
  //     }
  //   }
  //   return owned;
  // }

  // Future<bool> setOwned(Map<String, List<String>> owned) {
  //   final List<String> encoded = <String>[];
  //   for (String amiiboId in owned.keys) {
  //     final String e = _serializeList(amiiboId, owned[amiiboId]);
  //     encoded.add(e);
  //   }
  //   return _preferences.setStringList('owned', encoded);
  // }

  // String _serializeList(String amiiboId, List<String> regions) {
  //   return amiiboId + '@' + regions.join('|');
  // }

  // String _deserializeAmiiboId(String encoded) {
  //   assert(encoded.contains('@'));
  //   return encoded.split('@')[0];
  // }

  // List<String> _deserializeRegions(String encoded) {
  //   assert(encoded.contains('@'));
  //   final String encodedRegions = encoded.split('@')[1];
  //   assert(encodedRegions.length > 1);
  //   return encodedRegions.split('|');
  // }
}
