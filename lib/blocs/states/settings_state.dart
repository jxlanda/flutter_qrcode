import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

class SettingsState extends Equatable {
  final ThemeMode themeMode;

  SettingsState(this.themeMode) : assert(themeMode != null);

  @override
  List<Object> get props => [themeMode];
}
