import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/blocs/singles/createqr_bloc.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:qrcode/utils/utils.dart';

class CreateQRPage extends StatelessWidget {
  CreateQRPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building create QR page ...");
    // Establecemos el tamaño de la pantalla
    final double _screenHeight = MediaQuery.of(context).size.height;
    return BlocProvider<CreateQRBloc>(
      create: (context) => CreateQRBloc(),
      child: SingleChildScrollView(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxHeight: _screenHeight,
          ),
          child: Scaffold(
            appBar: AppBar(
              title: Text("Create"),
              centerTitle: true,
              elevation: 0.0,
            ),
            backgroundColor: Colors.blue,
            body: Stack(
              children: <Widget>[
                Align(
                  alignment: Alignment.topCenter,
                  child: QRPreview(),
                ),
                BlocBuilder<CreateQRBloc, CreateQRState>(
                  builder: (context, state) {
                    if (state is StepperFormState) {
                      // PanelController del bloc
                      final PanelController _panelCtrl =
                          context.bloc<CreateQRBloc>().panelController;
                      // Numero del step final del bloc
                      final int _finalStep =
                          context.bloc<CreateQRBloc>().finalStep;
                      // Lista de ScanTypes del bloc
                      final List<ScanTypes> _scanTypes =
                          context.bloc<CreateQRBloc>().scanTypes;
                      return SlidingUpPanel(
                        controller: _panelCtrl,
                        minHeight: _screenHeight / 2.2,
                        maxHeight: _screenHeight,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25.0),
                          topRight: Radius.circular(25.0),
                        ),
                        panelBuilder: (sc) => Column(
                          mainAxisAlignment: MainAxisAlignment.start,
                          mainAxisSize: MainAxisSize.max,
                          children: <Widget>[
                            HeaderPanel(),
                            Stepper(
                              currentStep: state.currentStep,
                              onStepContinue: () {
                                // Suma + 1 al currentStep
                                context.bloc<CreateQRBloc>().add(
                                      ChangeStep(
                                        step: (state.currentStep + 1),
                                      ),
                                    );
                              },
                              onStepCancel: () {
                                // Resta - 1 al currentStep
                                context.bloc<CreateQRBloc>().add(
                                      ChangeStep(
                                        step: (state.currentStep - 1),
                                      ),
                                    );
                              },
                              // physics: ScrollPhysics(),
                              controlsBuilder: (context,
                                      {onStepCancel, onStepContinue}) =>
                                  Padding(
                                padding: const EdgeInsets.only(top: 8.0),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.end,
                                  children: <Widget>[
                                    state.currentStep != 0
                                        ? FlatButton(
                                            color: Colors.grey[200],
                                            child: const Text('BACK'),
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(20.0),
                                            ),
                                            onPressed: onStepCancel,
                                          )
                                        : EmptyWidget(),
                                    SizedBox(
                                      width: 10.0,
                                    ),
                                    FlatButton(
                                      color: Colors.blue,
                                      textColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(20.0),
                                      ),
                                      child: state.currentStep != _finalStep
                                          ? const Text('NEXT')
                                          : const Text('CREATE'),
                                      onPressed: onStepContinue,
                                    ),
                                  ],
                                ),
                              ),
                              steps: [
                                Step(
                                  isActive:
                                      state.currentStep == 0 ? true : false,
                                  title: Text("Type"),
                                  content: Step0(scanTypes: _scanTypes),
                                ),
                                Step(
                                  isActive:
                                      state.currentStep == 1 ? true : false,
                                  title: Text("Data"),
                                  content: Step1(panelCtrl: _panelCtrl),
                                ),
                                Step(
                                  isActive:
                                      state.currentStep == 2 ? true : false,
                                  title: Text("Style"),
                                  subtitle: Text("Optional"),
                                  content: Step2(panelCtrl: _panelCtrl),
                                ),
                              ],
                            ),
                          ],
                        ),
                      );
                    } else
                      return EmptyWidget();
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class Step2 extends StatelessWidget {
  const Step2({
    Key key,
    @required PanelController panelCtrl,
  })  : _panelCtrl = panelCtrl,
        super(key: key);

  final PanelController _panelCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5.0,
        ),
        TextFormField(
          onTap: () => _panelCtrl.open(),
          decoration: InputDecoration(
            labelText: 'Text',
            border: OutlineInputBorder(),
          ),
        ),
        SizedBox(
          height: 10.0,
        ),
        TextFormField(
          decoration: InputDecoration(
            labelText: 'Text',
            border: OutlineInputBorder(),
          ),
        ),
      ],
    );
  }
}

class Step1 extends StatelessWidget {
  const Step1({
    Key key,
    @required PanelController panelCtrl,
  })  : _panelCtrl = panelCtrl,
        super(key: key);

  final PanelController _panelCtrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        SizedBox(
          height: 5.0,
        ),
        TextFormField(
          onTap: () => _panelCtrl.open(),
          decoration:
              InputDecoration(labelText: 'Text', border: OutlineInputBorder()),
        ),
      ],
    );
  }
}

class Step0 extends StatelessWidget {
  const Step0({
    Key key,
    @required List<ScanTypes> scanTypes,
  })  : _scanTypes = scanTypes,
        super(key: key);

  final List<ScanTypes> _scanTypes;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        DropdownButtonFormField(
          value: 0,
          onChanged: (value) {},
          decoration: InputDecoration(
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Colors.blue),
            ),
          ),
          items: _scanTypes
              .map(
                (item) => DropdownMenuItem(
                  value: item.index,
                  child: Row(
                    children: <Widget>[
                      IconByScanType(
                        scanType: item.value,
                        color: Colors.blue,
                      ),
                      SizedBox(width: 10.0),
                      Text(
                        item.value.capitalize(),
                      )
                    ],
                  ),
                ),
              )
              .toList(),
        )
      ],
    );
  }
}

class EmptyWidget extends StatelessWidget {
  const EmptyWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 0.0,
      height: 0.0,
    );
  }
}

class HeaderPanel extends StatelessWidget {
  const HeaderPanel({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 30,
      height: 5,
      margin: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.grey[400],
        borderRadius: BorderRadius.all(Radius.circular(20.0)),
      ),
    );
  }
}

class QRPreview extends StatelessWidget {
  const QRPreview({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.all(10.0),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: <Widget>[
          QrImage(
            data: "example",
            version: QrVersions.auto,
            size: 200,
            gapless: false,
          ),
          Text("PREVIEW")
        ],
      ),
    );
  }
}
