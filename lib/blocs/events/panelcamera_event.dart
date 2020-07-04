import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

abstract class PanelCameraEvent extends Equatable {
  const PanelCameraEvent();
}

class FoundQRCode extends PanelCameraEvent {
  final PanelController panelController;
  final String qr;

  const FoundQRCode({this.qr, @required this.panelController});

  @override
  String toString() => 'QR Code: $qr';

  @override
  List<Object> get props => [qr, panelController];
}

class NotFoundQRCode extends PanelCameraEvent {
  final PanelController panelController;

  const NotFoundQRCode({@required this.panelController});

  @override
  String toString() => 'QR Code not found';

  @override
  List<Object> get props => [panelController];
}

class ConnectingWifi extends PanelCameraEvent {
  final bool isConnecting;

  const ConnectingWifi({@required this.isConnecting});

  @override
  String toString() => 'Connection Wifi State: $isConnecting';

  @override
  List<Object> get props => [isConnecting];
}
