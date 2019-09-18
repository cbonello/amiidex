import 'package:amiidex/main.dart';
import 'package:amiidex/providers/amiibo_sort.dart';
import 'package:amiidex/providers/lock.dart';
import 'package:amiidex/providers/series_sort.dart';
import 'package:amiidex/providers/view_as.dart';
import 'package:amiidex/services/package_info.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalStorageService {
  static LocalStorageService _instance;
  static SharedPreferences _preferences;

  static Future<LocalStorageService> getInstance() async {
    _instance ??= LocalStorageService();
    _preferences ??= await SharedPreferences.getInstance();
    return _instance;
  }

  bool getDisplayOnboarding() {
    // To force display of onboarding pages whenver a new release is
    // installed.
    final PackageInfoService info = locator<PackageInfoService>();
    final String savedVersion =
        _preferences.getString('display_onboarding') ?? '';
    return savedVersion != info.version;
  }

  Future<bool> setDisplayOnboarding(bool display) {
    final PackageInfoService info = locator<PackageInfoService>();
    final String value = display ? '' : info.version;
    return _preferences.setString('display_onboarding', value);
  }

  String getPreferredLanguage() {
    return _preferences.getString('preferred_language') ?? 'en_US';
  }

  Future<bool> setPreferredLanguage(String lang) {
    return _preferences.setString('preferred_language', lang);
  }

  bool getDisplaySplashScreen() {
    return _preferences.getBool('display_plash_screen') ?? false;
  }

  Future<bool> setDisplaySplashScreen(bool display) {
    return _preferences.setBool('display_plash_screen', display);
  }

  String getRegion(String dft) {
    try {
      return _preferences.getString('region') ?? dft;
    } catch (_) {
      return dft;
    }
  }

  Future<bool> setRegion(String id) {
    return _preferences.setString('region', id);
  }

  String getRegionIndicator(String id, String dflt) {
    try {
      return _preferences.getString('${id}_indicator') ?? dflt;
    } catch (_) {
      return dflt;
    }
  }

  Future<bool> setRegionIndicator(String id, String code) {
    return _preferences.setString('${id}_indicator', code);
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
      sort = SeriesSortOrder.name_ascending;
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
      sort = AmiiboSortOrder.name_ascending;
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
      final int v = _preferences.getInt('${label}_view_as') ?? 1;
      type = DisplayType.values[v];
    } catch (_) {
      type = DisplayType.grid_small;
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
      owned = <String>[];
    }
    return owned;
  }

  Future<bool> setOwned(List<String> owned) {
    return _preferences.setStringList('owned', owned);
  }

  List<String> getSeriesFilter(List<String> dflt) {
    List<String> filter;
    try {
      filter = _preferences.getStringList('series_filter') ?? dflt;
    } catch (_) {
      filter = dflt;
    }
    return filter;
  }

  Future<bool> setSeriesFilter(List<String> filter) {
    return _preferences.setStringList('series_filter', filter);
  }
}
