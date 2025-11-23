import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:focusnote_app/component/bar/bar_data.dart';

class MyBarGraph extends StatelessWidget {
  final List weeklySummary;
  const MyBarGraph({
    super.key,
    required this.weeklySummary,
  });

  @override
  Widget build(BuildContext context) {
    // note: gunakan huruf kecil untuk instance
    BarData myBarGraph = BarData(
      sunAmount: weeklySummary[0],
      monAmount: weeklySummary[1],
      tueAmount: weeklySummary[2],
      wedAmount: weeklySummary[3],
      thuAmount: weeklySummary[4],
      friAmount: weeklySummary[5],
      satAmount: weeklySummary[6],
    );
    myBarGraph.initializeBarData();

    return BarChart(
      BarChartData(
        maxY: 10,
        minY: 0,
        gridData: FlGridData(show: false),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          show: true,
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          bottomTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              getTitlesWidget: getBottomTiles,
            ),
          ),
        ),
        barGroups: myBarGraph.barData
            .map(
              (data) => BarChartGroupData(
                x: data.x,
                barRods: [
                  BarChartRodData(
                    toY: data.y,
                    color: const Color.fromARGB(255, 255, 181, 112),
                    width: 25,
                    borderRadius: BorderRadius.circular(6),
                    backDrawRodData: BackgroundBarChartRodData(
                      show: true,
                      toY: 10,
                      color: Colors.grey.shade400,
                    ),
                  ),
                ],
              ),
            )
            .toList(),
      ),
    );
  }
}

Widget getBottomTiles(double value, TitleMeta meta) {
  final style = TextStyle(
    color: Colors.grey.shade800,
    fontWeight: FontWeight.bold,
    fontSize: 14,
  );

  Widget text;
  switch (value.toInt()) {
    case 0:
      text = Text('S', style: style);
      break;
    case 1:
      text = Text('S', style: style);
      break;
    case 2:
      text = Text('R', style: style);
      break;
    case 3:
      text = Text('K', style: style);
      break;
    case 4:
      text = Text('J', style: style);
      break;
    case 5:
      text = Text('S', style: style);
      break;
    case 6:
      text = Text('M', style: style);
      break;
    default:
      text = Text('', style: style);
      break;
  }

  return SideTitleWidget(
    meta: meta,
    child: text,
  );
}
