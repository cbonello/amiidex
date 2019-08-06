import 'dart:collection';

import 'package:amiidex/models/value_pack.dart';

class ValuePackList extends ListBase<ValuePackModel> {
  ValuePackList() {
    _list = <ValuePackModel>[];
  }

  factory ValuePackList.fromJson(String serieId, List<dynamic> valuePacks) {
    final ValuePackList l = ValuePackList();
    for (dynamic b in valuePacks) {
      l.add(ValuePackModel.fromJson(serieId, b));
    }
    return l;
  }

  factory ValuePackList.from(Iterable<ValuePackModel> elements) {
    final ValuePackList l = ValuePackList()..addAll(elements);
    return l;
  }

  List<ValuePackModel> _list;

  @override
  int get length => _list.length;

  @override
  set length(int length) {
    _list.length = length;
  }

  @override
  void operator []=(int index, ValuePackModel value) {
    _list[index] = value;
  }

  @override
  ValuePackModel operator [](int index) => _list[index];

  @override
  void add(ValuePackModel element) => _list.add(element);

  @override
  void addAll(Iterable<ValuePackModel> iterable) => _list.addAll(iterable);
}
