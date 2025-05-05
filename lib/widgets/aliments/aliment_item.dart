import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/aliments/aliment_modify.dart';

class AlimentItem extends StatefulWidget {
  AlimentItem({
    required this.aliment,
    required this.user,
    required this.fromPage,
    required this.aliments,
    this.onAddAliment,
    super.key,
  });

  final Aliment aliment;
  final User user;
  final String fromPage;
  List<Aliment> aliments;

  void Function(Aliment newAliment)? onAddAliment;

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

  /// Permet de modifier un aliment
  void _modifyAliment(Aliment modifiedAliment) {
    setState(() {
      aliment = modifiedAliment;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black,
              Color.fromARGB(255, 17, 127, 112),
            ],
            begin: Alignment.bottomRight,
            end: Alignment.topLeft,
          ),
        ),
        child: Card(
          child: InkWell(
            onTap: () {
              if (widget.fromPage == "Home") {
                showDialog(
                  context: context,
                  builder: (ctx) => AlimentModify(
                    user: widget.user,
                    aliment: aliment,
                    onModifyAliment: _modifyAliment,
                    aliments: widget.aliments,
                  ),
                );
              } else {
                widget.onAddAliment!(aliment);
              }
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
                      Text("Lipide: ${aliment.fats}")
                    ],
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
