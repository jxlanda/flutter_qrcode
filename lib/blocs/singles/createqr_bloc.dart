import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:qrcode/environment/environment.dart' as env;

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> {
  final PanelController panelController = new PanelController();
  final ScrollController singleChildController = new ScrollController();
  final List<env.ScanTypes> scanTypes = env.ScanTypes.values;
  // Form url
  final TextEditingController urlController = TextEditingController();
  // Form wifi
  final TextEditingController wifiSSIDCtrl = TextEditingController();
  final TextEditingController wifiPasswordCtrl = TextEditingController();
  final TextEditingController wifiEncryptionCtrl = TextEditingController();
  // Form location
  final TextEditingController locationLatCtrl = TextEditingController();
  final TextEditingController locationLonCtrl = TextEditingController();
  // Form email
  final TextEditingController emailCtrl = TextEditingController();
  final TextEditingController emailSubjectCtrl = TextEditingController();
  final TextEditingController emailBodyCtrl = TextEditingController();
  // Form phone
  final TextEditingController phoneNumberCtrl = TextEditingController();
  // Form sms
  final TextEditingController smsNumberCtrl = TextEditingController();
  final TextEditingController smsBodyCtrl = TextEditingController();
  // Form text
  final TextEditingController textCtrl = TextEditingController();
  // Stepper
  final finalStep = 2;
  // QR Code
  String scanType = "";
  String qrData = "example";
  Color qrColor = Colors.black;
  File qrImage;

  CreateQRBloc() : super(StepperFormState(currentStep: 0, completed: false));

  @override
  Stream<CreateQRState> mapEventToState(CreateQREvent event) async* {
    final StepperFormState stepper = state as StepperFormState;
    if (event is ChangeStep) {
      // Determina si el panel esta expandido o no
      if (!panelController.isPanelOpen) await panelController.open();
      // Si el currentStep es menor o igual a finalStep
      if (event.step <= finalStep) {
        yield stepper.copyWith(currentStep: event.step);
      }
    }
    // Step 0
    if (event is DrowpDownChange) {
      scanType = event.scanType;
    }
    // Step 1
    if (event is ChangeQRData) {
      qrData = event.data;
    }
    // Step 2
    if (event is ChangeQRStyle) {
      qrColor = event.color;
      if (event.image != null) {
        qrImage = event.image;
      }
      yield stepper.copyWith(
        currentStep: 2,
        color: qrColor.value.toString(),
        image: qrImage,
      );
    }
    // Completed form
    if (event is FormCompleted) {
      yield stepper.copyWith(completed: event.completed);
    }
  }
}
