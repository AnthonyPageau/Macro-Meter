import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';

class AlimentItem extends StatelessWidget {
  const AlimentItem(this.aliment, {super.key});

  final Aliment aliment;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: InkWell(
          onTap: () {},
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 16,
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      aliment.name,
                      style: Theme.of(context).textTheme.titleLarge,
                    ),
                    const Spacer(),
                    Icon(categoryIcons[aliment.category])
                  ],
                ),
                const SizedBox(
                  height: 4,
                ),
                Row(
                  children: [
                    Text("Calories: ${aliment.calories}"),
                    const Spacer(),
                    Text("Protéine: ${aliment.protein}"),
                    const Spacer(),
                    Text("Glucide: ${aliment.carbs}"),
                    const Spacer(),
                    Text("Lipide: ${aliment.fat}")
                  ],
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
