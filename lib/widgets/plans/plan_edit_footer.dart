import 'package:flutter/material.dart';
import 'package:macro_meter/models/plan.dart';

class PlanEditFooter extends StatefulWidget {
  const PlanEditFooter({required this.plan, super.key});

  final Plan plan;

  @override
  State<StatefulWidget> createState() {
    return _PlanEditFooterState();
  }
}

class _PlanEditFooterState extends State<PlanEditFooter> {
  late Plan plan;

  @override
  void initState() {
    super.initState();
    plan = widget.plan;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.black),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              children: [
                Text(""),
                Text("Total",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text("Prot",
                    style: TextStyle(fontSize: 18, color: Colors.white)),
                Text(plan.totalProteines().toString(),
                    style: TextStyle(fontSize: 18, color: Colors.white)),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  "Glu",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  plan.totalCarbs().toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  "Lip",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  plan.totalFats().toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
          Expanded(
            flex: 2,
            child: Column(
              children: [
                Text(
                  "Cal",
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
                Text(
                  plan.totalCalories().toString(),
                  style: TextStyle(fontSize: 18, color: Colors.white),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
