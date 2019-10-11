import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:stempeln/persistentData.dart';

class OptionsRoute extends StatefulWidget {
  @override
  _OptionsRouteState createState() => _OptionsRouteState();
}

class _OptionsRouteState extends State<OptionsRoute> {
  var persData = PersistentData();
  int localWorkingHour = 42;
  final _workingHoursController = TextEditingController();
  int localWorkingDay = 5;
  final _workingDaysController = TextEditingController();
  int localBreak = 1;
  final _breakController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: Center(
        child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <
            Widget>[
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _workingHoursController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Arbeitsstunden',
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .title,
                prefixText: 'ganze ',
                suffixText: 'Stunden',
                errorText: _workingHoursErrorText(_workingHoursController.text),
                suffixStyle: TextStyle(color: Colors.green),
                prefixStyle: TextStyle(color: Colors.green),
              ),
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
              maxLines: 1,
              //initialValue: localWorkingHour.toString(),
              onChanged: _setWorkingHours,
              //onFieldSubmitted: _setWorkingHours,
              enableInteractiveSelection: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _workingDaysController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Arbeitstage',
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .title,
                prefixText: 'ganze ',
                suffixText: 'Tage pro Woche',
                errorText: _workingDaysErrorText(_workingDaysController.text),
                suffixStyle: TextStyle(color: Colors.green),
                prefixStyle: TextStyle(color: Colors.green),
              ),
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
              maxLines: 1,
              //initialValue: localWorkingHour.toString(),
              onChanged: _setWorkingDays,
              //onFieldSubmitted: _setWorkingDays,
              enableInteractiveSelection: false,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: TextFormField(
              controller: _breakController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Pause',
                labelStyle: Theme
                    .of(context)
                    .textTheme
                    .title,
                prefixText: 'ganze ',
                suffixText: 'Minuten am Tag',
                errorText: _breakErrorText(_breakController.text),
                suffixStyle: TextStyle(color: Colors.green),
                prefixStyle: TextStyle(color: Colors.green),
              ),
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
              maxLines: 1,
              //initialValue: localWorkingHour.toString(),
              onChanged: _setBreak,
              //onFieldSubmitted: _setBreak,
              enableInteractiveSelection: false,
            ),
          ),
        ]),
      ),
    );
  }

  void _setWorkingHours(String value) {
    persData.setWorkingHoursPerWeek(int.parse(value));
  }

  void _workingHoursControllerListener() async {
    print("Working hours changed");
  }

  String _workingHoursErrorText(String value) {
    int intValue = int.parse(value);
    if (intValue == null) {
      return "Keine Zahl!";
    } else if (intValue < 1) {
      return "zu wenige Stunden!";
    } else if (intValue > 24 * 7) {
      return "zu viele Stunden!";
    } else {
      return null;
    }
  }

  void _setWorkingDays(String value) {
    persData.setWorkingDaysPerWeek(int.parse(value));
  }

  void _workingDaysControllerListener() async {
    print("Working days changed");
  }

  String _workingDaysErrorText(String value) {
    int intValue = int.parse(value);
    if (intValue == null) {
      return "Keine Zahl!";
    } else if (intValue < 1) {
      return "zu wenige Tage!";
    } else if (intValue > 7) {
      return "zu viele Tage!";
    } else {
      return null;
    }
  }

  void _setBreak(String value) {
    persData.setBreak(int.parse(value));
  }

  void _breakControllerListener() async {
    print("break changed");
  }

  String _breakErrorText(String value) {
    int intValue = int.parse(value);
    if (intValue == null) {
      return "Keine Zahl!";
    } else if (intValue < 0) {
      return "zu kurze Pause!";
    } else if (intValue > 60) {
      return "zu lange Pause!";
    } else {
      return null;
    }
  }

  @override
  void initState() {
    super.initState();
    _workingHoursController.text = "40";
    _workingHoursController.addListener(_workingHoursControllerListener);
    _workingHoursController.text = (persData.valid
        ? persData.getWorkingHoursPerWeek().toString()
        : "invalid");
    _workingDaysController.text = "5";
    _workingDaysController.addListener(_workingDaysControllerListener);
    _workingDaysController.text = (persData.valid
        ? persData.getWorkingDaysPerWeek().toString()
        : "invalid");
    _breakController.text = "42";
    _breakController.addListener(_breakControllerListener);
    _breakController.text = (persData.valid
        ? persData.getBreak().toString()
        : "invalid");

  }

  @override
  void dispose() {
    _workingHoursController.dispose();
    _workingDaysController.dispose();
    _breakController.dispose();
    super.dispose();
  }
}
