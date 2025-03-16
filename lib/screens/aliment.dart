import 'package:flutter/material.dart';
import 'package:macro_meter/models/aliment.dart';
import 'package:macro_meter/models/meal.dart';
import 'package:macro_meter/widgets/aliments/aliment_list.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:macro_meter/widgets/aliments/aliment_create.dart';

class AlimentScreen extends StatefulWidget {
  const AlimentScreen(
      {super.key,
      required this.user,
      required this.fromPage,
      this.meal,
      this.onAddAliment});

  final dynamic user;
  final String fromPage;
  final Meal? meal;
  final void Function(Aliment newAliment)? onAddAliment;

  @override
  State<StatefulWidget> createState() {
    return _AlimentState();
  }
}

class _AlimentState extends State<AlimentScreen> {
  dynamic aliments;
  @override
  void initState() {
    super.initState();
    fetchUserAlimentData();
  }

  void addAliment(Aliment newAliment) {
    if (widget.meal!.aliments
        .any((aliment) => aliment.name == newAliment.name)) {
      ScaffoldMessenger.of(context).clearSnackBars();
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("L'aliment est déjà dans le repas"),
        ),
      );
    } else {
      widget.onAddAliment!(newAliment);
      Navigator.of(context).pop();
    }
  }

  void fetchUserAlimentData() async {
    var collection = await FirebaseFirestore.instance
        .collection("users")
        .doc(widget.user.uid)
        .collection("aliments")
        .get();

    List<Aliment> alimentList = collection.docs.map((doc) {
      var alimentData = doc.data();
      return Aliment(
        id: doc.id,
        name: alimentData["name"],
        calories: alimentData["calories"],
        proteines: alimentData["proteines"],
        carbs: alimentData["carbs"],
        fat: alimentData["fat"],
        quantity: alimentData["quantity"],
        unit: Unit.values.byName(alimentData["unit"]),
        category: Category.values.byName(
          alimentData["category"],
        ),
      );
    }).toList();

    setState(() {
      aliments = alimentList;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          "Aliments",
          style: TextStyle(fontSize: 36),
        ),
        flexibleSpace: Center(
          child: Padding(
            padding: EdgeInsets.only(right: 56),
            child: const Text(
              "Aliments",
              style: TextStyle(fontSize: 36),
            ),
          ),
        ),
        actions: [
          IconButton(
              onPressed: () {},
              icon: const Icon(
                Icons.search,
                size: 40,
              )),
          IconButton(
            onPressed: () {
              showDialog(
                context: context,
                builder: (ctx) => AlimentCreate(
                    onAddAliment: (newAliment) {
                      setState(() {
                        aliments.add(newAliment);
                      });
                    },
                    user: widget.user,
                    aliments: aliments),
              );
            },
            icon: const Icon(
              Icons.add_circle,
              size: 40,
            ),
          ),
        ],
      ),
      body: Container(
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
        child: aliments == null
            ? const Center(child: CircularProgressIndicator())
            : Column(
                children: [
                  Expanded(
                    child: widget.fromPage == "Home"
                        ? AlimentList(
                            aliments: aliments,
                            user: widget.user,
                            fromPage: widget.fromPage,
                          )
                        : AlimentList(
                            aliments: aliments,
                            user: widget.user,
                            fromPage: widget.fromPage,
                            onAddAliment: (newAliment) {
                              addAliment(newAliment);
                            },
                          ),
                  )
                ],
              ),
      ),
    );
  }
}
