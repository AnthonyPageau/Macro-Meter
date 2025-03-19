import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/screens/plan_edit.dart';
import 'package:intl/intl.dart';

import 'package:macro_meter/models/plan.dart';

class PlanItem extends StatefulWidget {
  const PlanItem({required this.plan, required this.user, super.key});

  final Plan plan;
  final User user;

  @override
  State<PlanItem> createState() {
    return _AlimentItemState();
  }
}

class _AlimentItemState extends State<PlanItem> {
  late Plan plan;

  @override
  void initState() {
    super.initState();
    plan = widget.plan;
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
              Navigator.of(context).push(
                MaterialPageRoute(
                  builder: (ctx) => PlanEdit(
                    user: widget.user,
                    plan: plan,
                  ),
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 16,
              ),
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        plan.name,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      Text(
                        "Date Création: ${DateFormat('yyyy-MM-dd').format(plan.date)}",
                      ),
                    ],
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [Icon(Icons.arrow_forward)],
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
