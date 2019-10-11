import 'package:flutter/material.dart';
import 'package:stempeln/options_route.dart';
import 'package:stempeln/persistentData.dart';

void main() => runApp(MyApp());

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  final String _title = "Ausstempeln";

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: _title,
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(title: _title),
    );
  }
}

class _InputDropdown extends StatelessWidget {
  const _InputDropdown({
    Key key,
    this.child,
    this.labelText,
    this.valueText,
    this.valueStyle,
    this.onPressed,
  }) : super(key: key);

  final String labelText;
  final String valueText;
  final TextStyle valueStyle;
  final VoidCallback onPressed;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onPressed,
      child: InputDecorator(
        decoration: InputDecoration(
          labelText: labelText,
        ),
        baseStyle: valueStyle,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Text(valueText, style: valueStyle),
            Icon(
              Icons.arrow_drop_down,
              color: Theme.of(context).brightness == Brightness.light
                  ? Colors.grey.shade700
                  : Colors.white70,
            ),
          ],
        ),
      ),
    );
  }
}

class _TimePicker extends StatelessWidget {
  const _TimePicker({
    Key key,
    this.labelText,
    this.selectedTime,
    this.selectTime,
  }) : super(key: key);

  final String labelText;
  final TimeOfDay selectedTime;
  final ValueChanged<TimeOfDay> selectTime;

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay picked = await showTimePicker(
      context: context,
      initialTime: selectedTime,
    );
    if (picked != null && picked != selectedTime) selectTime(picked);
  }

  @override
  Widget build(BuildContext context) {
    final TextStyle valueStyle = Theme.of(context).textTheme.display1;
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: <Widget>[
        const SizedBox(width: 12.0),
        Expanded(
          flex: 3,
          child: _InputDropdown(
            valueText: selectedTime.format(context),
            valueStyle: valueStyle,
            onPressed: () {
              _selectTime(context);
            },
          ),
        ),
      ],
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  var persData = PersistentData();
  TimeOfDay _start = TimeOfDay.now();
  TimeOfDay _end = TimeOfDay.now();
  Duration _break = Duration(hours: 0, minutes: 45);
  Duration _weeklyWorkingTime = Duration(hours: 40, minutes: 0);
  int _numberOfWorkingDayPerWeek = 5;

  final gehenTextController = TextEditingController();

  _updateDuration(int value) {
    print("This value was asyncronously updated: $value");
    _weeklyWorkingTime = Duration(hours: value, minutes: 42);
  }

  void _calculateEnd() {
    print("calcutate End");
    //persData.getWorkingHoursPerWeek().then((onValue) => _updateDuration(onValue));
    _updateDuration(persData.getWorkingHoursPerWeek());
    print("WeeklyWorkingHours = $_weeklyWorkingTime");
    Duration _hoursPerDayWithBreak =
        _weeklyWorkingTime ~/ _numberOfWorkingDayPerWeek + _break;
    Duration _toLeave = _hoursPerDayWithBreak +
        Duration(hours: _start.hour, minutes: _start.minute);

    _end = TimeOfDay(
        hour: _toLeave.inHours % 24, minute: _toLeave.inMinutes % 60);
    gehenTextController.text =
        _end.hour.toString() + ":" + _end.minute.toString();
    setState(() {

    });
  }

  @override
  void initState() {
    super.initState();
    gehenTextController.text = "invalid";
    persData.init().then((onValue) => _calculateEnd());
  }

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return Scaffold(
      //key: _scaffoldKey,
      appBar: AppBar(
        // Here we take the value from the MyHomePage object that was created by
        // the App.build method, and use it to set our appbar title.
        title: Text(widget.title),

        actions: <Widget>[
          PopupMenuButton<String>(
              onSelected: _onSelectionOptions,
              itemBuilder: (BuildContext context) =>
              <PopupMenuItem<String>>[
                const PopupMenuItem<String>(
                    child: Text('Einstelungen'),
                    value: "Einstellungen value")
              ])
        ],
      ),
      body: Center(
        // Center is a layout widget. It takes a single child and positions it
        // in the middle of the parent.
        child: Column(
          // Column is also a layout widget. It takes a list of children and
          // arranges them vertically. By default, it sizes itself to fit its
          // children horizontally, and tries to be as tall as its parent.
          //
          // Invoke "debug painting" (press "p" in the console, choose the
          // "Toggle Debug Paint" action from the Flutter Inspector in Android
          // Studio, or the "Toggle Debug Paint" command in Visual Studio Code)
          // to see the wireframe for each widget.
          //
          // Column has various properties to control how it sizes itself and
          // how it positions its children. Here we use mainAxisAlignment to
          // center the children vertically; the main axis here is the vertical
          // axis because Columns are vertical (the cross axis would be
          // horizontal).
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                'Bitte die Zeit zum kommen eingeben',
                style: Theme.of(context).textTheme.display1,
              ),
            ),
            _TimePicker(
              labelText: 'From',
              selectedTime: _start,
              selectTime: (TimeOfDay time) {
                _calculateEnd();
                _start = time;
              },
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(
                "gehen:",
                style: Theme.of(context).textTheme.display1,
              ),
            ),
/*            Text(
            _end.hour.toString() + ":" + _end.minute.toString(),
              style: Theme.of(context).textTheme.display1,
            )*/
            TextField(
              controller: gehenTextController,
              style: Theme
                  .of(context)
                  .textTheme
                  .display1,
            )
          ],
        ),
      ),
    );
  }

  void _onSelectionOptions(String value) async {
    print("---------");
    print(value);
    final result = await Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => OptionsRoute()),

    );
    //if (result == true) {
    print("got back from options. result : $result");
    _calculateEnd();
    //}

  }
}
