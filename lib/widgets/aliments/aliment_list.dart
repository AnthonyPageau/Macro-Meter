import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/aliments/aliment_item.dart';

class AlimentList extends StatelessWidget {
  const AlimentList({super.key, required this.aliments});

  final List<Aliment> aliments;

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      itemCount: aliments.length,
      itemBuilder: (ctx, index) => Dismissible(
        key: ValueKey(
          aliments[index],
        ),
        background: Container(
          color: Theme.of(context).colorScheme.error,
          margin: EdgeInsets.symmetric(
            horizontal: Theme.of(context).cardTheme.margin!.horizontal,
          ),
        ),
        child: AlimentItem(aliments[index]),
      ),
    );
  }
}
