import 'package:flutter/material.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building settings page ...");
    return Scaffold(
      appBar: AppBar(
        title: Text("Settings"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Column(
        children: <Widget>[
          SizedBox(
            height: 30.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              StepHeader(),
              Container(
                width: 30.0,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              StepHeader(),
              Container(
                width: 30.0,
                child: Divider(
                  color: Colors.black,
                ),
              ),
              StepHeader(),
            ],
          ),
        ],
      ),
    );
  }
}

class StepHeader extends StatelessWidget {
  const StepHeader({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        SizedBox(
          width: 5.0,
        ),
        Container(
          width: 30.0,
          height: 30.0,
          decoration: new BoxDecoration(
            color: Colors.blue,
            shape: BoxShape.circle,
          ),
          child: Icon(
            Icons.edit,
            size: 20.0,
            color: Colors.white,
          ),
        ),
        SizedBox(
          width: 5.0,
        ),
        Text("Type"),
        SizedBox(
          width: 5.0,
        )
      ],
    );
  }
}
