import 'package:intl/intl.dart';
import 'package:macro_meter/presentation/ressources/app_ressources.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/main.dart';

import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class WeeklyChart extends StatefulWidget {
  WeeklyChart({super.key, required this.journals});

  final List<Journal> journals;

  final Color barBackgroundColor =
      AppColors.contentColorWhite.withValues(alpha: 0.3);
  final Color barColor = AppColors.contentColorWhite;
  final Color touchedBarColor = AppColors.contentColorGreen;

  @override
  State<StatefulWidget> createState() => WeeklyChartState();
}

class WeeklyChartState extends State<WeeklyChart> {
  final Duration animDuration = const Duration(milliseconds: 250);

  int touchedIndex = -1;
  double mondayAverage = 0;
  double thuesdayAverage = 0;
  double wednesdayAverage = 0;
  double thursdayAverage = 0;
  double fridayAverage = 0;
  double saturdayAverage = 0;
  double sundayAverage = 0;
  double mondayTotal = 0;
  double thuesdayTotal = 0;
  double wednesdayTotal = 0;
  double thursdayTotal = 0;
  double fridayTotal = 0;
  double saturdayTotal = 0;
  double sundayTotal = 0;
  int mondayCount = 0;
  int thuesdayCount = 0;
  int wednesdayCount = 0;
  int thursdayCount = 0;
  int fridayCount = 0;
  int saturdayCount = 0;
  int sundayCount = 0;

  void calculate() {
    for (Journal journal in widget.journals) {
      switch (DateFormat.EEEE().format(journal.date)) {
        case "Monday":
          mondayTotal += journal.totalCalories();
          mondayCount++;
        case "Thuesday":
          thuesdayTotal += journal.totalCalories();
          thuesdayCount++;
        case "Wednesday":
          wednesdayTotal += journal.totalCalories();
          wednesdayCount++;
        case "Thursday":
          thursdayTotal += journal.totalCalories();
          thursdayCount++;
        case "Friday":
          fridayTotal += journal.totalCalories();
          fridayCount++;
        case "Saturday":
          saturdayTotal += journal.totalCalories();
          saturdayCount++;
        case "Sunday":
          sundayTotal += journal.totalCalories();
          sundayCount++;
      }
    }

    mondayAverage = mondayTotal == 0 ? 0 : mondayTotal / mondayCount;
    thuesdayAverage = thuesdayTotal == 0 ? 0 : thuesdayTotal / thuesdayCount;
    wednesdayAverage =
        wednesdayTotal == 0 ? 0 : wednesdayTotal / wednesdayCount;
    thursdayAverage = thursdayTotal == 0 ? 0 : thursdayTotal / thursdayCount;
    fridayAverage = fridayTotal == 0 ? 0 : fridayTotal / fridayCount;
    saturdayAverage = saturdayTotal == 0 ? 0 : saturdayTotal / saturdayCount;
    sundayAverage = saturdayTotal == 0 ? 0 : sundayTotal / sundayCount;
  }

  void resetValues() {
    mondayAverage = 0;
    thuesdayAverage = 0;
    wednesdayAverage = 0;
    thursdayAverage = 0;
    fridayAverage = 0;
    saturdayAverage = 0;
    sundayAverage = 0;
    mondayTotal = 0;
    thuesdayTotal = 0;
    wednesdayTotal = 0;
    thursdayTotal = 0;
    fridayTotal = 0;
    saturdayTotal = 0;
    sundayTotal = 0;
    mondayCount = 0;
    thuesdayCount = 0;
    wednesdayCount = 0;
    thursdayCount = 0;
    fridayCount = 0;
    saturdayCount = 0;
    sundayCount = 0;
  }

  @override
  void didUpdateWidget(WeeklyChart oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.journals != widget.journals) {
      setState(() {
        resetValues();
        calculate();
      });
    }
  }

  @override
  void initState() {
    super.initState();
    setState(() {
      calculate();
    });
  }

  @override
  Widget build(BuildContext context) {
    return AspectRatio(
      aspectRatio: 1,
      child: Stack(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                const SizedBox(
                  height: 38,
                ),
                Text(
                  "Calories consommées par \n journée de la semaine",
                  style: TextStyle(
                      fontSize: 26, color: kColorScheme.primaryContainer),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(
                  height: 38,
                ),
                Expanded(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8),
                    child: BarChart(
                      mainBarData(),
                    ),
                  ),
                ),
                const SizedBox(
                  height: 12,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  BarChartGroupData makeGroupData(
    int x,
    double y, {
    bool isTouched = false,
    Color? barColor,
    double width = 22,
    List<int> showTooltips = const [],
  }) {
    barColor ??= widget.barColor;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: isTouched ? y + 1 : y,
          color: isTouched ? widget.touchedBarColor : barColor,
          width: width,
          borderSide: isTouched
              ? BorderSide(color: widget.touchedBarColor)
              : const BorderSide(color: Colors.white, width: 0),
          backDrawRodData: BackgroundBarChartRodData(
            show: true,
            toY: 3300,
            color: widget.barBackgroundColor,
          ),
        ),
      ],
      showingTooltipIndicators: showTooltips,
    );
  }

  List<BarChartGroupData> showingGroups() => List.generate(7, (i) {
        switch (i) {
          case 0:
            return makeGroupData(0, mondayAverage,
                isTouched: i == touchedIndex);
          case 1:
            return makeGroupData(1, thuesdayAverage,
                isTouched: i == touchedIndex);
          case 2:
            return makeGroupData(2, wednesdayAverage,
                isTouched: i == touchedIndex);
          case 3:
            return makeGroupData(3, thursdayAverage,
                isTouched: i == touchedIndex);
          case 4:
            return makeGroupData(4, fridayAverage,
                isTouched: i == touchedIndex);
          case 5:
            return makeGroupData(5, saturdayAverage,
                isTouched: i == touchedIndex);
          case 6:
            return makeGroupData(6, sundayAverage,
                isTouched: i == touchedIndex);
          default:
            return throw Error();
        }
      });

  BarChartData mainBarData() {
    return BarChartData(
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipColor: (_) => Colors.blueGrey,
          tooltipHorizontalAlignment: FLHorizontalAlignment.left,
          tooltipMargin: -10,
          getTooltipItem: (group, groupIndex, rod, rodIndex) {
            String weekDay;
            switch (group.x) {
              case 0:
                weekDay = 'Lundi';
                break;
              case 1:
                weekDay = 'Mardi';
                break;
              case 2:
                weekDay = 'Mercredi';
                break;
              case 3:
                weekDay = 'Jeudi';
                break;
              case 4:
                weekDay = 'Vendredi';
                break;
              case 5:
                weekDay = 'Samedi';
                break;
              case 6:
                weekDay = 'Dimanche';
                break;
              default:
                throw Error();
            }
            return BarTooltipItem(
              '$weekDay\n',
              const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 18,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: (rod.toY - 1).toString(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            );
          },
        ),
        touchCallback: (FlTouchEvent event, barTouchResponse) {
          setState(() {
            if (!event.isInterestedForInteractions ||
                barTouchResponse == null ||
                barTouchResponse.spot == null) {
              touchedIndex = -1;
              return;
            }
            touchedIndex = barTouchResponse.spot!.touchedBarGroupIndex;
          });
        },
      ),
      titlesData: FlTitlesData(
        show: true,
        rightTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        topTitles: const AxisTitles(
          sideTitles: SideTitles(showTitles: false),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            getTitlesWidget: getTitles,
            reservedSize: 38,
          ),
        ),
        leftTitles: const AxisTitles(
          sideTitles: SideTitles(
            showTitles: false,
          ),
        ),
      ),
      borderData: FlBorderData(
        show: false,
      ),
      barGroups: showingGroups(),
      gridData: const FlGridData(show: false),
    );
  }

  Widget getTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.bold,
      fontSize: 14,
    );
    Widget text;
    switch (value.toInt()) {
      case 0:
        text = const Text('L', style: style);
        break;
      case 1:
        text = const Text('M', style: style);
        break;
      case 2:
        text = const Text('M', style: style);
        break;
      case 3:
        text = const Text('J', style: style);
        break;
      case 4:
        text = const Text('V', style: style);
        break;
      case 5:
        text = const Text('S', style: style);
        break;
      case 6:
        text = const Text('D', style: style);
        break;
      default:
        text = const Text('', style: style);
        break;
    }
    return SideTitleWidget(
      meta: meta,
      space: 16,
      child: text,
    );
  }
}
