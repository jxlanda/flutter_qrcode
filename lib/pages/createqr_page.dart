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
      body: Stepper(
          type: StepperType.horizontal,
          controlsBuilder: (context, {onStepCancel, onStepContinue}) => Column(
                children: <Widget>[
                  SizedBox(
                    height: 50.0,
                  ),
                  Row(
                    children: <Widget>[
                      FlatButton(
                        onPressed: onStepContinue,
                        child: const Text('NEXT'),
                      ),
                      FlatButton(
                        onPressed: onStepCancel,
                        child: const Text('CANCEL'),
                      ),
                    ],
                  ),
                ],
              ),
          steps: [
            Step(
              title: Text("Type"),
              content: Column(
                children: <Widget>[Text("QR Code Type")],
              ),
            ),
            Step(
              title: Text("Data"),
              content: Text("QR Code Data"),
            ),
            Step(
              title: Text("Style"),
              subtitle: Text("Optional"),
              content: Text("QR Code Style"),
            ),
          ]),
    );
  }
}
