import 'package:flutter/foundation.dart';

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
