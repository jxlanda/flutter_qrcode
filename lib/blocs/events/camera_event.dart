import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

abstract class CameraEvent extends Equatable {
  const CameraEvent();
}

class ToggleFlash extends CameraEvent {
  final bool flash;

  const ToggleFlash({@required this.flash});

  @override
  String toString() => 'Flash: $flash';

  @override
  List<Object> get props => [flash];
}

class ToggleCamera extends CameraEvent {
  final bool camera;

  const ToggleCamera({@required this.camera});

  @override
  String toString() => 'FrontCamera: $camera';

  @override
  List<Object> get props => [camera];
}

class QRViewCreated extends CameraEvent {
  final QRViewController qrViewController;

  const QRViewCreated({@required this.qrViewController});

  @override
  List<Object> get props => [qrViewController];
}

class FoundQR extends CameraEvent {
  final PanelController panelController;
  final String qr;

  const FoundQR({this.qr, @required this.panelController});

  @override
  String toString() => 'QR Text: $qr';

  @override
  List<Object> get props => [qr, panelController];
}

class NotFoundQR extends CameraEvent {
  final PanelController panelController;

  const NotFoundQR({@required this.panelController});

  @override
  String toString() => 'QR not found';

  @override
  List<Object> get props => [panelController];
}

class ConnectWifi extends CameraEvent {
  final bool isConnecting;

  const ConnectWifi({@required this.isConnecting});

  @override
  String toString() => 'Connection Wifi State: $isConnecting';

  @override
  List<Object> get props => [isConnecting];
}
