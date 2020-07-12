import 'dart:io';

import 'package:flutter/material.dart';
import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateQREvent extends Equatable {
  const CreateQREvent();
}

class ChangeStep extends CreateQREvent {
  final int step;

  const ChangeStep({@required this.step});

  @override
  List<Object> get props => [step];

  @override
  String toString() => 'Go to Step: $step';
}

class DrowpDownChange extends CreateQREvent {
  final String scanType;

  const DrowpDownChange({@required this.scanType});

  @override
  List<Object> get props => [scanType];

  @override
  String toString() => 'DropDown ScanType: $scanType';
}

class ChangeQRData extends CreateQREvent {
  final String data;

  const ChangeQRData({@required this.data});

  @override
  List<Object> get props => [data];

  @override
  String toString() => 'Data: $data';
}

class ChangeQRStyle extends CreateQREvent {
  final Color color;
  final File image;
  const ChangeQRStyle({@required this.color, this.image});

  @override
  List<Object> get props => [color, image];

  @override
  String toString() => 'Color: ${color.value}';
}
