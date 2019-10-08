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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Einstellungen"),
      ),
      body: Center(
        child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Text(
                "bla",
                style: Theme
                    .of(context)
                    .textTheme
                    .display1,
              ),
              TextFormField(
                controller: _workingHoursController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  labelText: 'Arbeitsstunden',
                  prefixText: 'ganze',
                  suffixText: 'Stunden',
                  //suffixStyle: TextStyle(color: Colors.green),
                ),
                maxLines: 1,
                //initialValue: localWorkingHour.toString(),
                onChanged: _setWorkingHours,
              ),
            ]
        ),
      ),
    );
  }

  _setWorkingHours(String value) {
    persData.setWorkingHoursPerWeek(int.parse(value));
  }

  Future<String> _getWorkingHours() async
  {
    var hours = await persData.getWorkingHoursPerWeek();
    return hours.toString();
  }

  void _workingHoursControllerListener() async
  {
    //localWorkingHour = await _getWorkingHours();
    //save...
  }

  @override
  void initState() {
    super.initState();
    _workingHoursController.text = "420";
    _workingHoursController.addListener(_workingHoursControllerListener);
    //_getWorkingHours().then((onValue) => _workingHoursController.text = onValue);
    _workingHoursController.text =
    (persData.valid ? persData.getWorkingHoursPerWeek().toString() : "invalid");
  }

  @override
  void dispose() {
    _workingHoursController.dispose();
    super.dispose();
  }


}

