import 'package:macro_meter/presentation/ressources/app_ressources.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/journal.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/main.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class AlimentCategoryChart extends StatefulWidget {
  const AlimentCategoryChart({required this.journals, super.key});

  final List<Journal> journals;

  @override
  State<StatefulWidget> createState() => _AlimentCategoryChartState();
}

class _AlimentCategoryChartState extends State<AlimentCategoryChart> {
  num proteines = 0;
  num dairy = 0;
  num cereal = 0;
  num fruitsAndVegetable = 0;
  num other = 0;
  double proteinesPercentage = 0;
  double dairyPercentage = 0;
  double cerealPercentage = 0;
  double fruitsAndVegetablePercentage = 0;
  double otherPercentage = 0;
  num total = 0;
  int touchedIndex = 0;

  void calculate() {
    for (Journal journal in widget.journals) {
      for (Meal meal in journal.plan.meals) {
        for (Aliment aliment in meal.aliments) {
          switch (aliment.category) {
            case AlimentCategory.protein:
              proteines += aliment.quantity;
              total += aliment.quantity;
              break;
            case AlimentCategory.cereal:
              cereal += aliment.quantity;
              total += aliment.quantity;
              break;
            case AlimentCategory.dairy:
              dairy += aliment.quantity;
              total += aliment.quantity;
              break;
            case AlimentCategory.fruitsAndVegetable:
              fruitsAndVegetable += aliment.quantity;
              total += aliment.quantity;
              break;
            case AlimentCategory.other:
              other += aliment.quantity;
              total += aliment.quantity;
              break;
          }
        }
      }
    }
    proteinesPercentage = proteines / total * 100;
    cerealPercentage = cereal / total * 100;
    dairyPercentage = dairy / total * 100;
    fruitsAndVegetablePercentage = fruitsAndVegetable / total * 100;
    otherPercentage = other / total * 100;
  }

  void resetValues() {
    proteines = 0;
    dairy = 0;
    cereal = 0;
    fruitsAndVegetable = 0;
    other = 0;
    proteinesPercentage = 0;
    dairyPercentage = 0;
    cerealPercentage = 0;
    fruitsAndVegetablePercentage = 0;
    otherPercentage = 0;
    total = 0;
  }

  @override
  void didUpdateWidget(AlimentCategoryChart oldWidget) {
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
          "Catégories d'aliments\r consommés",
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
    return List.generate(5, (i) {
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
              Icon(categoryIcons[AlimentCategory.protein]),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 1:
          return PieChartSectionData(
            color: AppColors.contentColorYellow,
            value: cerealPercentage,
            title: "${cerealPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon(categoryIcons[AlimentCategory.cereal]),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 2:
          return PieChartSectionData(
            color: AppColors.contentColorPurple,
            value: dairyPercentage,
            title: "${dairyPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon(categoryIcons[AlimentCategory.dairy]),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 3:
          return PieChartSectionData(
            color: AppColors.contentColorGreen,
            value: fruitsAndVegetablePercentage,
            title: "${fruitsAndVegetablePercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon(categoryIcons[AlimentCategory.fruitsAndVegetable]),
              size: widgetSize,
              borderColor: AppColors.contentColorBlack,
            ),
            badgePositionPercentageOffset: .98,
          );
        case 4:
          return PieChartSectionData(
            color: AppColors.contentColorRed,
            value: otherPercentage,
            title: "${otherPercentage.toStringAsFixed(0)}%",
            radius: radius,
            titleStyle: TextStyle(
              fontSize: fontSize,
              fontWeight: FontWeight.bold,
              color: const Color(0xffffffff),
              shadows: shadows,
            ),
            badgeWidget: _Badge(
              Icon(categoryIcons[AlimentCategory.other]),
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
