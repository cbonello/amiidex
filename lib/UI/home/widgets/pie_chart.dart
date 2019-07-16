import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:sprintf/sprintf.dart';

class OwnedMissingPieChart extends StatelessWidget {
  const OwnedMissingPieChart({
    Key key,
    @required this.ownedCount,
    @required this.missingCount,
  }) : super(key: key);

  final double ownedCount, missingCount;

  @override
  Widget build(BuildContext context) {
    List<PieChartSectionData> pieChartRawSections;
    List<PieChartSectionData> showingSections;

    final double count = ownedCount + missingCount;
    pieChartRawSections = <PieChartSectionData>[];
    if (ownedCount > 0) {
      pieChartRawSections.add(PieChartSectionData(
        color: const Color(0xFF44B035),
        value: ownedCount,
        title: '${(ownedCount / count * 100).toStringAsFixed(2)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    if (missingCount > 0) {
      pieChartRawSections.add(PieChartSectionData(
        color: const Color(0xFFE60012),
        value: missingCount,
        title: '${(missingCount / count * 100).toStringAsFixed(2)}%',
        radius: 80,
        titleStyle: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    showingSections = pieChartRawSections;

    Widget pie() {
      return Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.2,
                  child: FlChart(
                    chart: PieChart(
                      PieChartData(
                        borderData: FlBorderData(
                          show: false,
                        ),
                        sectionsSpace: 0,
                        centerSpaceRadius: 40,
                        sections: showingSections,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              if (ownedCount > 0)
                Legend(
                  color: const Color(0xFF44B035),
                  text: sprintf(
                    I18n.of(context).text('piechart-owned'),
                    <int>[
                      ownedCount.toInt(),
                    ],
                  ),
                  isSquare: true,
                ),
              const SizedBox(
                width: 20.0,
              ),
              if (missingCount > 0)
                Legend(
                  color: const Color(0xFFE60012),
                  text: sprintf(
                    I18n.of(context).text('piechart-missing'),
                    <int>[
                      missingCount.toInt(),
                    ],
                  ),
                  isSquare: true,
                ),
            ],
          ),
        ],
      );
    }

    return Container(
      child: Center(
        child: Padding(
          padding: const EdgeInsets.all(5.0),
          child: pie(),
        ),
      ),
    );
  }
}

class Legend extends StatelessWidget {
  const Legend({
    Key key,
    this.color,
    this.text,
    this.isSquare,
    this.size = 16,
    this.textColor = const Color(0xff505050),
  }) : super(key: key);

  final Color color;
  final String text;
  final bool isSquare;
  final double size;
  final Color textColor;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Container(
          width: size,
          height: size,
          decoration: BoxDecoration(
            shape: isSquare ? BoxShape.rectangle : BoxShape.circle,
            color: color,
          ),
        ),
        const SizedBox(width: 4),
        Text(
          text,
          style: TextStyle(
              fontSize: 16, fontWeight: FontWeight.bold, color: textColor),
        )
      ],
    );
  }
}
