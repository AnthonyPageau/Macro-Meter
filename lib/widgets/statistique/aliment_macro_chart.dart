import 'package:macro_meter/presentation/ressources/app_ressources.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class AlimentMacroChart extends StatefulWidget {
  const AlimentMacroChart({required this.journals, super.key});

  final List<Journal> journals;

  @override
  State<StatefulWidget> createState() => _AlimentMacroChartState();
}

class _AlimentMacroChartState extends State<AlimentMacroChart> {
  num proteines = 0;
  num fats = 0;
  num carbs = 0;
  double proteinesPercentage = 0;
  double fatsPercentage = 0;
  double carbsPercentage = 0;
  num total = 0;
  int touchedIndex = 0;

  void calculate() {
    for (Journal journal in widget.journals) {
      for (Meal meal in journal.plan.meals) {
        for (Aliment aliment in meal.aliments) {
          proteines += aliment.proteines;
          fats += aliment.fats;
          carbs += aliment.carbs;
          total += aliment.proteines;
          total += aliment.carbs;
          total += aliment.fats;
        }
      }
    }
    proteinesPercentage = proteines / total * 100;
    fatsPercentage = fats / total * 100;
    carbsPercentage = carbs / total * 100;
  }

  void resetValues() {
    proteines = 0;
    fats = 0;
    carbs = 0;
    proteinesPercentage = 0;
    fatsPercentage = 0;
    carbsPercentage = 0;
    total = 0;
  }

  @override
  void didUpdateWidget(AlimentMacroChart oldWidget) {
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
    return Column(
      children: [
        Text(
          "Valeurs nutritives \n consommées",
          style: TextStyle(fontSize: 26, color: kColorScheme.primaryContainer),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 12),
        SizedBox(
          height: 250,
          width: 250,
          child: PieChart(
            PieChartData(
              pieTouchData: PieTouchData(
                touchCallback: (FlTouchEvent event, pieTouchResponse) {
                  setState(() {
                    if (!event.isInterestedForInteractions ||
                        pieTouchResponse == null ||
                        pieTouchResponse.touchedSection == null) {
                      touchedIndex = -1;
                      return;
                    }
                    touchedIndex =
                        pieTouchResponse.touchedSection!.touchedSectionIndex;
                  });
                },
              ),
              borderData: FlBorderData(
                show: false,
              ),
              sectionsSpace: 0,
              centerSpaceRadius: 0,
              sections: showingSections(),
            ),
          ),
        ),
      ],
    );
  }

  List<PieChartSectionData> showingSections() {
    return List.generate(3, (i) {
      final isTouched = i == touchedIndex;
      final fontSize = isTouched ? 20.0 : 16.0;
      final radius = isTouched ? 110.0 : 100.0;
      final widgetSize = isTouched ? 55.0 : 40.0;
      const shadows = [Shadow(color: Colors.black, blurRadius: 2)];

      switch (i) {
        case 0:
          return PieChartSectionData(
            color: AppColors.contentColorBlue,
            value: proteinesPercentage,
            title: "${proteinesPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon(FontAwesomeIcons.drumstickBite),
              size: widgetSize,
              borderColor: const Color.fromARGB(255, 4, 2, 2),
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: const Color.fromRGBO(255, 195, 0, 1),
            value: carbsPercentage,
            title: "${carbsPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon((FontAwesomeIcons.seedling)),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: fatsPercentage,
            title: "${fatsPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon((FontAwesomeIcons.bottleDroplet)),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        default:
          throw Exception('Oh no');
      }
    });
  }
}

class _Badge extends StatelessWidget {
  const _Badge(
    this.svgAsset, {
    required this.size,
    required this.borderColor,
  });
  final Icon svgAsset;
  final double size;
  final Color borderColor;

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: PieChart.defaultDuration,
      width: size,
      height: size,
      decoration: BoxDecoration(
        color: Colors.white,
        shape: BoxShape.circle,
        border: Border.all(
          color: borderColor,
          width: 2,
        ),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color: Colors.black.withValues(alpha: .5),
            offset: const Offset(3, 3),
            blurRadius: 3,
          ),
        ],
      ),
      padding: EdgeInsets.all(size * .15),
      child: Center(child: svgAsset),
    );
  }
}
