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
      body: Center(
        child: Text("Settings"),
      ),
    );
  }
}
