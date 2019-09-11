import 'package:flutter/foundation.dart';
import 'package:amiidex/main.dart';
import 'package:amiidex/services/local_storage.dart';

enum LockStatus {
  opened,
  locked,
}

// Lock/ Unlock of amiibo collection. A locked collection cannot be
// updated.
class LockProvider with ChangeNotifier {
  LockProvider() {
    _status = storageService.getLockStatus();
  }

  final LocalStorageService storageService = locator<LocalStorageService>();
  LockStatus _status;

  bool get isLocked => _status == LockStatus.locked;
  bool get isOpened => _status == LockStatus.opened;

  void toggleLock() {
    _status = isOpened ? LockStatus.locked : LockStatus.opened;
    storageService.setLockStatus(_status);
    notifyListeners();
  }
}
