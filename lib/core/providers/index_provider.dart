import 'package:flutter/foundation.dart';

class IndexProvider with ChangeNotifier, DiagnosticableTreeMixin {
  int _index = 0;

  int get index => _index;

  set index(int value) {
    _index = value;
    notifyListeners();
  }

  @override
  void debugFillProperties(DiagnosticPropertiesBuilder properties) {
    super.debugFillProperties(properties);
    properties.add(IntProperty('index', _index));
  }
}
