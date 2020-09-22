import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:amiidex/util/i18n.dart';
import 'package:sprintf/sprintf.dart';

class OwnedMissingPieChart extends StatefulWidget {
  const OwnedMissingPieChart({
    Key key,
    @required this.ownedCount,
    @required this.missedCount,
  }) : super(key: key);

  final double ownedCount, missedCount;

  @override
  _OwnedMissingPieChartState createState() => _OwnedMissingPieChartState();
}

class _OwnedMissingPieChartState extends State<OwnedMissingPieChart> {
  int touchedIndex;

  @override
  Widget build(BuildContext context) {
    final List<PieChartSectionData> pieChartRawSections =
        <PieChartSectionData>[];
    final double total = widget.ownedCount + widget.missedCount;

    if (widget.ownedCount > 0) {
      final bool isTouched = touchedIndex == 0;
      pieChartRawSections.add(PieChartSectionData(
        color: const Color(0xFF44B035),
        value: widget.ownedCount,
        title: '${(widget.ownedCount / total * 100).toStringAsFixed(2)}%',
        radius: isTouched ? 100 : 80,
        titleStyle: TextStyle(
          fontSize: isTouched ? 25 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }
    if (widget.missedCount > 0) {
      final bool isTouched =
          (pieChartRawSections.isEmpty && touchedIndex == 0) ||
              touchedIndex == 1;
      pieChartRawSections.add(PieChartSectionData(
        color: const Color(0xFFE60012),
        value: widget.missedCount,
        title: '${(widget.missedCount / total * 100).toStringAsFixed(2)}%',
        radius: isTouched ? 100 : 80,
        titleStyle: TextStyle(
          fontSize: isTouched ? 25 : 16,
          fontWeight: FontWeight.bold,
          color: Colors.white,
        ),
      ));
    }

    return Center(
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Expanded(
                child: AspectRatio(
                  aspectRatio: 1.3,
                  child: ExcludeSemantics(
                    child: PieChart(
                      PieChartData(
                        pieTouchData: PieTouchData(touchCallback: (
                          PieTouchResponse pieTouchResponse,
                        ) {
                          setState(() {
                            if (pieTouchResponse.touchInput is FlLongPressEnd ||
                                pieTouchResponse.touchInput is FlPanEnd) {
                              touchedIndex = -1;
                            } else {
                              touchedIndex =
                                  pieTouchResponse.touchedSectionIndex;
                            }
                          });
                        }),
                        borderData: FlBorderData(show: false),
                        sectionsSpace: 0,
                        centerSpaceRadius: 30,
                        sections: pieChartRawSections,
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
              if (widget.ownedCount > 0)
                Legend(
                  color: const Color(0xFF44B035),
                  text: sprintf(
                    I18n.of(context).text('piechart-owned'),
                    <int>[widget.ownedCount.toInt()],
                  ),
                  textColor: Theme.of(context).textTheme.headline6.color,
                  isSquare: true,
                ),
              const SizedBox(width: 20.0),
              if (widget.missedCount > 0)
                Legend(
                  color: const Color(0xFFE60012),
                  text: sprintf(
                    I18n.of(context).text('piechart-missing'),
                    <int>[widget.missedCount.toInt()],
                  ),
                  textColor: Theme.of(context).textTheme.headline6.color,
                  isSquare: true,
                ),
            ],
          ),
        ],
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
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: textColor,
          ),
        )
      ],
    );
  }
}
