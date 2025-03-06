import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/plan.dart';
import 'package:macro_meter/widgets/plans/plan_item.dart';

class PlanList extends StatelessWidget {
  const PlanList({super.key, required this.plans, required this.user});

  final List<Plan> plans;
  final User user;

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
        child: PlanItem(
          plan: plans[index],
          user: user,
        ),
      ),
    );
  }
}
