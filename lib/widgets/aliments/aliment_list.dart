import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/widgets/aliments/aliment_item.dart';

class AlimentList extends StatefulWidget {
  AlimentList(
      {super.key,
      required this.aliments,
      required this.user,
      required this.fromPage,
      this.onAddAliment});

  final List<Aliment> aliments;
  final dynamic user;
  final String fromPage;
  void Function(Aliment newAliment)? onAddAliment;

  @override
  State<StatefulWidget> createState() {
    return _AlimentListState();
  }
}

class _AlimentListState extends State<AlimentList> {
  // You can store the list of aliments in the state
  late List<Aliment> aliments;

  @override
  void initState() {
    super.initState();
    // Initialize the aliments list here
    aliments = widget.aliments;
  }

  void deleteAliment(Aliment aliment) {
    setState(() {
      aliments.remove(aliment);
    });

    var doc = FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
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
          deleteAliment(aliments[index]);
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
        child: widget.fromPage == "Home"
            ? AlimentItem(
                aliment: aliments[index],
                user: widget.user,
                fromPage: widget.fromPage,
                aliments: aliments,
              )
            : AlimentItem(
                aliment: aliments[index],
                user: widget.user,
                fromPage: widget.fromPage,
                onAddAliment: (newAliment) {
                  widget.onAddAliment!(newAliment);
                },
                aliments: aliments,
              ),
      ),
    );
  }
}
