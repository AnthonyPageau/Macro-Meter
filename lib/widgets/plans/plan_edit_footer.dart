import 'package:flutter/material.dart';

class PlanEditFooter extends StatefulWidget {
  const PlanEditFooter({super.key});

  @override
  State<StatefulWidget> createState() {
    return _PlanEditFooterState();
  }
}

class _PlanEditFooterState extends State<PlanEditFooter> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 150,
      decoration: BoxDecoration(color: Colors.black),
    );
  }
}
