import 'dart:async';

import 'package:amiidex/application.dart';
import 'package:amiidex/services/assets.dart';
import 'package:amiidex/services/local_storage.dart';
import 'package:amiidex/services/package_info.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

bool get isInDebugMode {
  bool inDebugMode = false;
  assert(inDebugMode = true);
  return inDebugMode;
}

Future<void> _reportError(dynamic error, dynamic stackTrace) async {
  print('Caught error: $error');
  if (isInDebugMode) {
    print(stackTrace);
  }
}

final GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  final LocalStorageService iLocalStorageService =
      await LocalStorageService.getInstance();
  locator.registerSingleton<LocalStorageService>(iLocalStorageService);

  final AssetsService iAssetsService = await AssetsService.getInstance();
  locator.registerSingleton<AssetsService>(iAssetsService);

  final PackageInfoService iPackageInfoService =
      await PackageInfoService.getInstance();
  locator.registerSingleton<PackageInfoService>(iPackageInfoService);
}

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await setupLocator();

  // Captures errors reported by the Flutter framework.
  FlutterError.onError = (FlutterErrorDetails details) {
    if (isInDebugMode) {
      FlutterError.dumpErrorToConsole(details);
    } else {
      Zone.current.handleUncaughtError(details.exception, details.stack);
    }
  };

  await runZonedGuarded<Future<void>>(
    () async {
      runApp(Application());
    },
    (dynamic error, dynamic stackTrace) {
      _reportError(error, stackTrace);
    },
  );
}
