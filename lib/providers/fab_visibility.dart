import 'package:flutter/foundation.dart';

// FAB is hidden when scrolling up, and displayed when scrolling down.
class FABVisibility with ChangeNotifier {
  FABVisibility() {
    _visible = true;
  }

  bool _visible;

  bool get isVisible => _visible;

  set visible(bool visible) {
    _visible = visible;
    notifyListeners();
  }
}
