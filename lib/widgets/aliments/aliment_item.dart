import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/aliments/aliment_modify.dart';

class AlimentItem extends StatefulWidget {
  const AlimentItem({required this.aliment, required this.user, super.key});

  final Aliment aliment;
  final User user;

  @override
  State<AlimentItem> createState() {
    return _AlimentItemState();
  }
}

class _AlimentItemState extends State<AlimentItem> {
  late Aliment aliment;

  @override
  void initState() {
    super.initState();
    aliment = widget.aliment;
  }

  void _modifyAliment(Aliment modifiedAliment) {
    setState(() {
      aliment = modifiedAliment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Card(
        child: InkWell(
          onTap: () {
            showDialog(
              context: context,
              builder: (ctx) => AlimentModify(
                user: widget.user,
                aliment: aliment,
                onModifyAliment: _modifyAliment,
              ),
            );
          },
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
                    Text("Protéine: ${aliment.proteines}"),
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
