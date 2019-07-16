import 'dart:collection';

import 'package:flutter/material.dart';
import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/util/i18n.dart';

enum AmiiboSortOrder {
  name_ascending,
  name_descending,
  release_date_ascending,
  release_date_descending,
}

class AmiiboList extends ListBase<AmiiboModel> {
  AmiiboList() {
    _list = <AmiiboModel>[];
  }

  factory AmiiboList.fromJson(String serieId, List<dynamic> amiibo) {
    final AmiiboList l = AmiiboList();
    for (dynamic a in amiibo) {
      l.add(AmiiboModel.fromJson(serieId, a));
    }
    return l;
  }

  factory AmiiboList.from(Iterable<AmiiboModel> elements) {
    final AmiiboList l = AmiiboList()..addAll(elements);
    return l;
  }

  List<AmiiboModel> _list;

  @override
  int get length => _list.length;

  @override
  set length(int length) {
    _list.length = length;
  }

  @override
  void operator []=(int index, AmiiboModel value) {
    _list[index] = value;
  }

  @override
  AmiiboModel operator [](int index) => _list[index];

  @override
  void add(AmiiboModel element) => _list.add(element);

  @override
  void addAll(Iterable<AmiiboModel> iterable) => _list.addAll(iterable);

  void sortByNameRegion(
    BuildContext context,
    AmiiboSortOrder order,
    String regionId,
  ) {
    switch (order) {
      case AmiiboSortOrder.name_ascending:
        _list.sort((AmiiboModel a, AmiiboModel b) {
          final String aName = I18n.of(context).text(a.id);
          final String bName = I18n.of(context).text(b.id);
          return aName.compareTo(bName);
        });
        break;
      case AmiiboSortOrder.name_descending:
        _list.sort((AmiiboModel a, AmiiboModel b) {
          final String aName = I18n.of(context).text(a.id);
          final String bName = I18n.of(context).text(b.id);
          return bName.compareTo(aName);
        });
        break;
      case AmiiboSortOrder.release_date_ascending:
        final AmiiboList notReleasedInRegion = AmiiboList.from(_list)
          ..removeWhere(
            (AmiiboModel a) => a.region(regionId) != null,
          );
        final AmiiboList releasedInRegion = AmiiboList.from(_list)
          ..removeWhere(
            (AmiiboModel a) => a.region(regionId) == null,
          );
        releasedInRegion.sort((AmiiboModel a, AmiiboModel b) {
          return a
              .region(regionId)
              .releaseDate
              .compareTo(b.region(regionId).releaseDate);
        });
        _list.clear();
        _list.addAll(notReleasedInRegion);
        _list.addAll(releasedInRegion);
        break;
      case AmiiboSortOrder.release_date_descending:
        final AmiiboList notReleasedInRegion = AmiiboList.from(_list)
          ..removeWhere(
            (AmiiboModel a) => a.region(regionId) != null,
          );
        final AmiiboList releasedInRegion = AmiiboList.from(_list)
          ..removeWhere(
            (AmiiboModel a) => a.region(regionId) == null,
          );
        releasedInRegion.sort((AmiiboModel a, AmiiboModel b) {
          return b
              .region(regionId)
              .releaseDate
              .compareTo(a.region(regionId).releaseDate);
        });
        _list.clear();
        _list.addAll(notReleasedInRegion);
        _list.addAll(releasedInRegion);
        break;
      default:
        assert(false);
    }
  }
}
