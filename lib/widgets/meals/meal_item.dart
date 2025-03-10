import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/aliment_list.dart';

class MealItem extends StatefulWidget {
  const MealItem({required this.meal, required this.user, super.key});

  final Meal meal;
  final User user;

  @override
  State<StatefulWidget> createState() {
    return _MealItemState();
  }
}

class _MealItemState extends State<MealItem> {
  late Meal meal;
  Aliment aliment = Aliment(
      id: "id",
      name: "name",
      calories: 10,
      protein: 10,
      carbs: 10,
      fat: 10,
      unit: Unit.grams,
      quantity: 100,
      category: Category.cereal);
  List<Aliment> aliments = [];
  @override
  void initState() {
    super.initState();
    aliments.add(aliment);
    meal = widget.meal;
  }

  @override
  Widget build(BuildContext context) {
    return Material(
      child: Column(
        children: [
          Card(
            elevation: 4,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: EdgeInsets.fromLTRB(16, 4, 0, 4),
                  decoration: BoxDecoration(
                    color: Colors.black,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(15),
                      topRight: Radius.circular(15),
                    ),
                  ),
                  alignment: Alignment.centerLeft,
                  child: Row(
                    children: [
                      Text(
                        meal.name,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 18,
                            fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                        onPressed: () {},
                        icon: const Icon(
                          Icons.edit,
                          color: Colors.white,
                        ),
                      ),
                      const Spacer(),
                      IconButton(
                          onPressed: () {},
                          icon: const Icon(
                            Icons.more_vert,
                            color: Colors.white,
                            size: 40,
                          ))
                    ],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(12),
                  decoration: BoxDecoration(color: Colors.grey),
                  alignment: Alignment.centerRight,
                  child: Text(
                    "Calories",
                    style: TextStyle(fontSize: 22),
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(color: Colors.white),
                    child: AlimentList(aliments: aliments, user: widget.user)),
                Container(
                  padding: EdgeInsets.fromLTRB(12, 12, 24, 12),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          Text(""),
                          Text("Total", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Prot", style: TextStyle(fontSize: 16)),
                          Text("0", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Glu", style: TextStyle(fontSize: 16)),
                          Text("0", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                      Column(
                        children: [
                          Text("Lip", style: TextStyle(fontSize: 16)),
                          Text("0", style: TextStyle(fontSize: 16)),
                        ],
                      ),
                    ],
                  ),
                ),
                Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.only(
                        bottomLeft: Radius.circular(15),
                        bottomRight: Radius.circular(15),
                      ),
                    ),
                    alignment: Alignment.centerLeft,
                    child: TextButton(
                        onPressed: () {}, child: Text("+ Ajouter aliment"))),
              ],
            ),
          ),
          Container(
              padding: EdgeInsets.only(left: 14),
              alignment: Alignment.centerLeft,
              child: ElevatedButton(
                  onPressed: () {}, child: const Text("Ajouter Repas")))
        ],
      ),
    );
  }
}
