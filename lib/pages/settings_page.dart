import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/blocs/blocs.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building settings page ...");
    return BlocBuilder<SettingsBloc, SettingsState>(
      builder: (context, state) => Scaffold(
        appBar: AppBar(
          title: Text("Settings"),
          centerTitle: true,
          elevation: 0.0,
        ),
        body: Column(
          children: <Widget>[
            Container(
              color: Theme.of(context).cardColor,
              child: ListTile(
                title: Text("Modo oscuro"),
                trailing: Switch(
                  value: state.themeMode == ThemeMode.dark ? true : false,
                  onChanged: (value) {
                    BlocProvider.of<SettingsBloc>(context)
                        .add(ThemeChanged(value));
                  },
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
