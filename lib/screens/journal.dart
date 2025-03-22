import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:macro_meter/widgets/journals/date_picker_widget.dart';

class JournalScreen extends StatefulWidget {
  const JournalScreen({super.key});

  @override
  State<StatefulWidget> createState() {
    return _JournalScreenState();
  }
}

class _JournalScreenState extends State<JournalScreen> {
  dynamic date = DateTime.now();
  String dateDisplayed = DateFormat('yyyy-MM-dd').format(DateTime.now());
  void displayDate(DateTime newDate) {
    if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd').format(DateTime.now())) {
      dateDisplayed = "Aujourd'hui";
    } else if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().subtract(const Duration(days: 1)))) {
      dateDisplayed = "Hier";
    } else if (DateFormat('yyyy-MM-dd').format(newDate) ==
        DateFormat('yyyy-MM-dd')
            .format(DateTime.now().add(const Duration(days: 1)))) {
      dateDisplayed = "Demain";
    } else {
      dateDisplayed = DateFormat('yyyy-MM-dd').format(newDate);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          title: Text(
            "Journal",
            style: TextStyle(fontSize: 36),
          ),
        ),
        body: Container(
          decoration: BoxDecoration(color: Colors.black),
          height: 100,
          width: double.infinity,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              const SizedBox(
                width: 30,
              ),
              Row(
                children: [
                  IconButton(
                    onPressed: () {
                      setState(() {
                        date = date.subtract(const Duration(days: 1));
                        displayDate(date);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_back_ios_new,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                  TextButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (ctx) => DatePickerExample()),
                      );
                    },
                    child: Text(
                      dateDisplayed,
                      style: TextStyle(color: Colors.white, fontSize: 24),
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      setState(() {
                        date = date.add(const Duration(days: 1));
                        displayDate(date);
                      });
                    },
                    icon: Icon(
                      Icons.arrow_forward_ios,
                      color: Colors.white,
                      size: 30,
                    ),
                  ),
                ],
              ),
              IconButton(
                onPressed: () {},
                icon: Icon(
                  Icons.check,
                  color: Colors.white,
                  size: 30,
                ),
              ),
            ],
          ),
        ));
  }
}
