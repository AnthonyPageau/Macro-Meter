import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/plans/plan_item.dart';

class PlanList extends StatelessWidget {
  const PlanList(
      {super.key,
      required this.plans,
      required this.user,
      required this.fromPage,
      this.onChoosePlan});

  final List<Plan> plans;
  final User user;
  final String fromPage;
  final void Function(Plan choosePlan)? onChoosePlan;

  void deletePlan(Plan plan) async {
    var docRef = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("plans")
        .doc(plan.id);

    CollectionReference colMeals = docRef.collection("meals");

    QuerySnapshot collectionMealsSnapshot = await colMeals.get();
    for (var doc in collectionMealsSnapshot.docs) {
      CollectionReference colAliments = doc.reference.collection("aliments");
      QuerySnapshot collectionAlimentSnapshot = await colAliments.get();
      for (var doc in collectionAlimentSnapshot.docs) {
        await doc.reference.delete();
      }
      doc.reference.delete();
    }
    docRef.delete();
  }

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: plans.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(
          plans[index],
        ),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          deletePlan(plans[index]);
        },
        confirmDismiss: (direction) async {
          return await showDialog(
            context: context,
            builder: (ctx) => AlertDialog(
              title: Text("Voulez-vous vraiment supprimer?"),
              actions: [
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(false),
                  child: Text("Cancel"),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.of(ctx).pop(true),
                  child: Text("Supprimer"),
                ),
              ],
            ),
          );
        },
        child: fromPage == "Journal"
            ? PlanItem(
                plan: plans[index],
                user: user,
                fromPage: fromPage,
                onChoosePlan: (chosePlan) {
                  onChoosePlan!(chosePlan);
                },
              )
            : PlanItem(
                plan: plans[index],
                user: user,
                fromPage: fromPage,
              ),
      ),
    );
  }
}
