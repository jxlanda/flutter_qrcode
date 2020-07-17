import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_colorpicker/flutter_colorpicker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/blocs/singles/createqr_bloc.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:qrcode/utils/utils.dart' as utils;

class CreateQRPage extends StatelessWidget {
  CreateQRPage({Key key, this.keyboardSize = 0.0}) : super(key: key);
  final double keyboardSize;

  @override
  Widget build(BuildContext context) {
    print("Building create QR page ...");
    return BlocProvider<CreateQRBloc>(
      create: (context) => CreateQRBloc(),
      child: Scaffold(
        appBar: AppBar(
          title: Text("Create"),
          centerTitle: true,
          elevation: 0.0,
        ),
        backgroundColor: Theme.of(context).primaryColor,
        body: BlocBuilder<CreateQRBloc, CreateQRState>(
          builder: (context, state) {
            if (state is StepperFormState) {
              // PanelController del bloc
              final PanelController _panelCtrl =
                  context.bloc<CreateQRBloc>().panelController;
              // Numero del step final del bloc
              final int _finalStep = context.bloc<CreateQRBloc>().finalStep;
              // Lista de ScanTypes del bloc
              final List<ScanTypes> _scanTypes =
                  context.bloc<CreateQRBloc>().scanTypes;
              // Establecemos el tamaño de la pantalla
              final double _screenHeight = MediaQuery.of(context).size.height;
              // Verificamos si el formulario se completo
              final bool completed = state.completed;
              // Obtenemos la informacion del qr
              final String _qrData = context.bloc<CreateQRBloc>().qrData;
              // Obtenemos la informacion del qr
              final Color _qrColor = context.bloc<CreateQRBloc>().qrColor;
              return completed
                  ? Column(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: QRPreview(
                            qrData: context.bloc<CreateQRBloc>().qrData,
                            qrColor: context.bloc<CreateQRBloc>().qrColor,
                            qrImage: context.bloc<CreateQRBloc>().qrImage,
                            qrSize: _screenHeight / 2.4,
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            FlatButton(
                              color: Colors.grey,
                              textColor: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text("Back"),
                              onPressed: () => context
                                  .bloc<CreateQRBloc>()
                                  .add(FormCompleted(completed: false)),
                            ),
                            SizedBox(
                              width: 40.0,
                            ),
                            FlatButton(
                              color: Colors.white,
                              textColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0),
                              ),
                              child: Text("Save"),
                              onPressed: () async {
                                await utils
                                    .toQRImageData(_qrData, color: _qrColor)
                                    .then((success) {
                                  success
                                      ? utils.showCustomSnackBar(
                                          context, "QR Code saved in gallery")
                                      : utils.showCustomSnackBar(
                                          context, "Could not save QRCode");
                                });
                              },
                            ),
                          ],
                        ),
                      ],
                    )
                  : Stack(
                      children: <Widget>[
                        Align(
                          alignment: Alignment.topCenter,
                          child: QRPreview(
                            qrData: context.bloc<CreateQRBloc>().qrData,
                            qrColor: context.bloc<CreateQRBloc>().qrColor,
                            qrImage: context.bloc<CreateQRBloc>().qrImage,
                            qrSize: _screenHeight / 4,
                          ),
                        ),
                        SlidingUpPanel(
                          controller: _panelCtrl,
                          minHeight: _screenHeight / 2.2,
                          maxHeight: _screenHeight - 100,
                          borderRadius: BorderRadius.only(
                            topLeft: Radius.circular(25.0),
                            topRight: Radius.circular(25.0),
                          ),
                          color: Theme.of(context).cardColor,
                          panelBuilder: (_) => Column(
                            mainAxisAlignment: MainAxisAlignment.start,
                            mainAxisSize: MainAxisSize.max,
                            children: <Widget>[
                              HeaderPanel(),
                              Expanded(
                                child: Stepper(
                                  currentStep: state.currentStep,
                                  onStepContinue: () {
                                    if (state.currentStep == 2) {
                                      context
                                          .bloc<CreateQRBloc>()
                                          .add(FormCompleted(completed: true));
                                      return;
                                    }
                                    // Quitamos el foco de los textFields
                                    FocusScope.of(context).unfocus();
                                    // Suma + 1 al currentStep
                                    context.bloc<CreateQRBloc>().add(
                                          ChangeStep(
                                            step: (state.currentStep + 1),
                                          ),
                                        );
                                  },
                                  onStepCancel: () {
                                    // Quitamos el foco de los textFields
                                    FocusScope.of(context).unfocus();
                                    // Resta - 1 al currentStep
                                    context.bloc<CreateQRBloc>().add(
                                          ChangeStep(
                                            step: (state.currentStep - 1),
                                          ),
                                        );
                                  },
                                  physics: ScrollPhysics(),
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
                                                colorBrightness:
                                                    Theme.of(context)
                                                        .accentColorBrightness,
                                                // textColor: Theme.of(context)
                                                //     .textSelectionColor,
                                                child: const Text('BACK'),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          20.0),
                                                ),
                                                onPressed: onStepCancel,
                                              )
                                            : EmptyWidget(),
                                        SizedBox(
                                          width: 10.0,
                                        ),
                                        FlatButton(
                                          color: Theme.of(context).accentColor,
                                          textColor: Theme.of(context)
                                              .textSelectionColor,
                                          shape: RoundedRectangleBorder(
                                            borderRadius:
                                                BorderRadius.circular(20.0),
                                          ),
                                          child: state.currentStep != _finalStep
                                              ? const Text('NEXT')
                                              : const Text('FINISH'),
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
                                      content: Step2(),
                                    ),
                                  ],
                                ),
                              ),
                              // Si hay teclado activo tomara su alto - 20, si no 0
                              SizedBox(
                                  height: keyboardSize == 0
                                      ? keyboardSize
                                      : keyboardSize - 20),
                            ],
                          ),
                        ),
                      ],
                    );
            } else
              return EmptyWidget();
          },
        ),
      ),
    );
  }
}

class Step2 extends StatelessWidget {
  const Step2({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final Color _currentColor = context.bloc<CreateQRBloc>().qrColor;
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        ListTile(
          title: Text("Color"),
          subtitle: Text("Select foreground color"),
          trailing: Container(
            width: 40.0,
            height: 40.0,
            decoration:
                BoxDecoration(color: _currentColor, shape: BoxShape.circle),
          ),
          onTap: () {
            showDialog(
              context: context,
              builder: (_) {
                return AlertDialog(
                  title: Text("Select a color:"),
                  content: SingleChildScrollView(
                    child: BlockPicker(
                      pickerColor: _currentColor,
                      onColorChanged: (Color color) {
                        context
                            .bloc<CreateQRBloc>()
                            .add(ChangeQRStyle(color: color));
                        // Cerramos el modal
                        Navigator.of(context).pop();
                      },
                    ),
                  ),
                );
              },
            );
          },
        ),
        ListTile(
          title: Text("Image"),
          subtitle: Text("Select foreground image"),
          trailing: Container(
            width: 40.0,
            height: 40.0,
            child: (context.bloc<CreateQRBloc>().qrImage != null)
                ? Image.file(context.bloc<CreateQRBloc>().qrImage)
                : Icon(
                    Icons.image,
                    size: 40.0,
                  ),
            decoration: BoxDecoration(shape: BoxShape.rectangle),
          ),
          onTap: () async {
            File _image;
            final PickedFile pickedFile =
                await ImagePicker().getImage(source: ImageSource.gallery);
            if (pickedFile != null) {
              _image = File(pickedFile.path);
              context
                  .bloc<CreateQRBloc>()
                  .add(ChangeQRStyle(color: _currentColor, image: _image));
            }
          },
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
    return FormByScanType(
      scanType: context.bloc<CreateQRBloc>().scanType,
      panelCtrl: _panelCtrl,
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
          onChanged: (index) {
            final type = _scanTypes[index].value;
            context.bloc<CreateQRBloc>().add(
                  DrowpDownChange(scanType: type),
                );
          },
          decoration: InputDecoration(
            enabled: true,
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10.0),
              borderSide: BorderSide(color: Theme.of(context).accentColor),
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
                        color: Theme.of(context).accentColor,
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
    @required this.qrData,
    this.qrColor,
    this.qrImage,
    this.qrSize = 320,
  }) : super(key: key);

  final String qrData;
  final Color qrColor;
  final File qrImage;
  final double qrSize;

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
      child: (qrImage != null)
          ? QrImage(
              data: qrData,
              version: QrVersions.auto,
              size: qrSize,
              gapless: false,
              foregroundColor: qrColor,
              embeddedImage: FileImage(qrImage),
              embeddedImageStyle: QrEmbeddedImageStyle(
                size: Size(qrSize / 5, qrSize / 5),
              ),
            )
          : QrImage(
              data: qrData,
              version: QrVersions.auto,
              size: qrSize,
              gapless: false,
              foregroundColor: qrColor,
            ),
    );
  }
}
