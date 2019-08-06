import 'package:amiidex/models/amiibo.dart';
import 'package:amiidex/models/amiibo_box.dart';
import 'package:amiidex/models/amiibo_list.dart';
import 'package:amiidex/models/serie.dart';
import 'package:amiidex/models/serie_list.dart';

class LineupModel {
  const LineupModel(this._series, this._amiibo);

  factory LineupModel.fromJson(Map<String, dynamic> json) {
    assert(json['lineup'] != null);

    final Map<String, SerieModel> series = <String, SerieModel>{};
    final Map<String, AmiiboModel> amiibo = <String, AmiiboModel>{};

    json['lineup'].forEach((dynamic s) {
      final SerieModel serie = SerieModel.fromJson(s);
      series[serie.id] = serie;
      for (AmiiboModel a in serie.amiibo) {
        amiibo[a.id] = a;
      }
    });

    return LineupModel(series, amiibo);
  }

  final Map<String, SerieModel> _series;
  final Map<String, AmiiboModel> _amiibo;

  SeriesList get series => SeriesList.from(_series.values);

  SerieModel getSerieById(String id) {
    assert(_series.containsKey(id));
    return _series[id];
  }

  AmiiboList get amiibo => AmiiboList.from(_amiibo.values);

  int get amiiboCount => _amiibo.length;

  AmiiboModel getAmiiboById(String id) {
    assert(_amiibo.containsKey(id));
    return _amiibo[id];
  }

  AmiiboBoxModel matchBarcode(String barcode) {
    for (SerieModel s in series) {
      final AmiiboBoxModel match = s.matchBarcode(barcode);
      if (match != null) {
        return match;
      }
    }
    return null;
  }
}
