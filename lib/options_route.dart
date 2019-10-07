import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class OptionsRoute extends StatefulWidget {
  @override
  _OptionsRouteState createState() => _OptionsRouteState();
}

class _OptionsRouteState extends State<OptionsRoute> {
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
                  style: Theme.of(context).textTheme.display1,
                )
              ]),
        ));
  }
}
