import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/meals/aliment_item.dart';

class AlimentList extends StatelessWidget {
  const AlimentList({super.key, required this.aliments, required this.user});

  final List<Aliment> aliments;
  final User user;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      shrinkWrap: true,
      itemCount: aliments.length,
      itemBuilder: (context, index) {
        return AlimentItem(aliment: aliments[index], user: user);
      },
    );
  }
}
