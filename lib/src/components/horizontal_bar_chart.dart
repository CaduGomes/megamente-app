import 'package:app_medidores_inteligentes/src/colors.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class Value {
  final double value;
  final String month;

  Value(this.value, this.month);
}

class _BarChart extends StatelessWidget {
  final List<Value> values;
  const _BarChart({Key? key, required this.values}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BarChart(
      BarChartData(
        barTouchData: barTouchData,
        borderData: borderData,
        barGroups: barGroups(),
        titlesData: titlesData,
        gridData: FlGridData(show: false),
        alignment: BarChartAlignment.spaceAround,
        maxY: 200,
      ),
    );
  }

  BarTouchData get barTouchData => BarTouchData(
        enabled: false,
        touchTooltipData: BarTouchTooltipData(
          tooltipBgColor: Colors.transparent,
          tooltipPadding: const EdgeInsets.all(0),
          tooltipMargin: 8,
          getTooltipItem: (
            BarChartGroupData group,
            int groupIndex,
            BarChartRodData rod,
            int rodIndex,
          ) {
            return BarTooltipItem(
              rod.toY.round().toString(),
              const TextStyle(
                color: secondary,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      );

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Color(0xff7589a2),
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    String text = values[value.toInt()].month;

    return SideTitleWidget(
      axisSide: meta.axisSide,
      space: 4.0,
      child: Text(text, style: style),
    );
  }

  FlTitlesData get titlesData => FlTitlesData(
        show: true,
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 20,
            getTitlesWidget: getTitles,
          ),
        ),
        topTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        rightTitles: AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
      );

  FlBorderData get borderData => FlBorderData(
        show: false,
      );

  final _barsGradient = const LinearGradient(
    colors: [
      primary,
      secondary,
    ],
    begin: Alignment.bottomCenter,
    end: Alignment.topCenter,
  );

  List<BarChartGroupData> barGroups() {
    List<BarChartGroupData> barChartGroups = [];
    for (int i = 0; i < values.length; i++) {
      barChartGroups.add(BarChartGroupData(
        x: i,
        barRods: [
          BarChartRodData(
            toY: values[i].value,
            gradient: _barsGradient,
          )
        ],
        showingTooltipIndicators: [0],
      ));
    }

    return barChartGroups;
  }
}

class DefaultBarChart extends StatelessWidget {
  final List<Value> values;
  const DefaultBarChart({super.key, required this.values});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 16.0),
      child: AspectRatio(
        aspectRatio: 1.7,
        child: _BarChart(values: values),
      ),
    );
  }
}
