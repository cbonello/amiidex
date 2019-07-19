import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/util/i18n.dart';

enum SeriesSortOrder {
  name_ascending,
  name_descending,
}

class SeriesList extends ListBase<SerieModel> {
  SeriesList() {
    _list = <SerieModel>[];
  }

  factory SeriesList.fromJson(List<dynamic> series) {
    final SeriesList l = SeriesList();
    for (dynamic s in series) {
      l.add(SerieModel.fromJson(s));
    }
    return l;
  }

  factory SeriesList.from(Iterable<SerieModel> elements) {
    final SeriesList l = SeriesList()..addAll(elements);
    return l;
  }

  List<SerieModel> _list;

  @override
  int get length => _list.length;

  @override
  set length(int length) {
    _list.length = length;
  }

  @override
  SerieModel operator [](int index) => _list[index];

  @override
  void operator []=(int index, SerieModel value) {
    _list[index] = value;
  }

  @override
  void add(SerieModel element) => _list.add(element);

  @override
  void addAll(Iterable<SerieModel> iterable) => _list.addAll(iterable);

  void sortByName(BuildContext context, SeriesSortOrder order) {
    if (order == SeriesSortOrder.name_ascending) {
      _list.sort((SerieModel a, SerieModel b) {
        final String aName = I18n.of(context).text(a.id);
        final String bName = I18n.of(context).text(b.id);
        return aName.compareTo(bName);
      });
    } else {
      _list.sort((SerieModel a, SerieModel b) {
        final String aName = I18n.of(context).text(a.id);
        final String bName = I18n.of(context).text(b.id);
        return bName.compareTo(aName);
      });
    }
  }
}
