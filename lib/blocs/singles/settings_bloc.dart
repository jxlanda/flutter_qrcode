import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/environment/environment.dart' as env;
import '../blocs.dart';
// Hive
import 'package:hive/hive.dart';

class SettingsBloc extends Bloc<SettingsEvent, SettingsState> {
  // Asignamos la base de datos: settings
  Box<bool> settings = Hive.box<bool>(env.HiveSettings);

  SettingsBloc() : super(SettingsState(ThemeMode.light));

  @override
  Stream<SettingsState> mapEventToState(SettingsEvent event) async* {
    if (event is ThemeLoadStarted) {
      yield* _mapThemeLoadStartedToState();
    } else if (event is ThemeChanged) {
      yield* _mapThemeChangedToState(event.value);
    }
  }

  Stream<SettingsState> _mapThemeLoadStartedToState() async* {
    final darkMode = settings.get('darkMode', defaultValue: false);
    ThemeMode themeMode = darkMode ? ThemeMode.dark : ThemeMode.light;
    yield SettingsState(themeMode);
  }

  Stream<SettingsState> _mapThemeChangedToState(bool value) async* {
    final darkMode = settings.get('darkMode', defaultValue: false);

    if (value && !darkMode) {
      settings.put('darkMode', true);
      yield SettingsState(ThemeMode.dark);
    } else if (!value && darkMode) {
      settings.put('darkMode', false);
      yield SettingsState(ThemeMode.light);
    }
  }
}
