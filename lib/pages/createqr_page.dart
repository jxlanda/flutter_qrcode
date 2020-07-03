import 'package:flutter/material.dart';

class CreateQRPage extends StatelessWidget {
  const CreateQRPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building create QR page ...");
    return Scaffold(
      appBar: AppBar(
        title: Text("Create"),
        centerTitle: true,
        elevation: 0.0,
      ),
      body: Center(
        child: Text("Create"),
      ),
    );
  }
}
