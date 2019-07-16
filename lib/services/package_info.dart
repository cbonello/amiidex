import 'package:package_info/package_info.dart';

class PackageInfoService {
  static PackageInfoService _instance;

  static Future<PackageInfoService> getInstance() async {
    if (_instance == null) {
      _instance = PackageInfoService();
      final PackageInfo packageInfo = await PackageInfo.fromPlatform();
      _instance.appName = packageInfo.appName;
      _instance.packageName = packageInfo.packageName;
      _instance.version = packageInfo.version;
      _instance.buildNumber = packageInfo.buildNumber;
    }
    return _instance;
  }

  String appName, packageName, version, buildNumber;
}
