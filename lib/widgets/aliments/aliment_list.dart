import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/aliments/aliment_item.dart';

class AlimentList extends StatelessWidget {
  const AlimentList({super.key, required this.aliments, required this.user});

  final List<Aliment> aliments;
  final dynamic user;

  void supprimerAliment(Aliment aliment) {
    aliments.remove(aliment);
    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc(user.uid)
        .collection("aliments")
        .doc(aliment.id);

    doc.delete();
  }

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
        direction: DismissDirection.endToStart,
        onDismissed: (direction) {
          supprimerAliment(aliments[index]);
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
        child: AlimentItem(aliments[index]),
      ),
    );
  }
}
