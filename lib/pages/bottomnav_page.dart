import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'pages.dart';

class BottomNavPage extends StatelessWidget {
  const BottomNavPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building bottom navigation page...");
    // Determina si hay teclado en la pantalla
    final bool isKeyboardActive =
        MediaQuery.of(context).viewInsets.bottom > 0.0;
    return BlocBuilder<BottomNavigationBloc, BottomNavigationState>(
      builder: (context, state) => Scaffold(
        body: IndexedStack(
          index: context.bloc<BottomNavigationBloc>().currentIndex,
          children: <Widget>[
            HomePage(),
            HistoryPage(),
            CreateQRPage(),
            SettingsPage()
          ],
        ),
        extendBody: true,
        floatingActionButton: isKeyboardActive ? NoFAB() : FAB(),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        bottomNavigationBar: BottomAppBarWithFab(),
      ),
    );
  }
}

class FAB extends StatelessWidget {
  const FAB({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      child: Icon(FlutterIcons.qrcode_scan_mco),
      elevation: 2.5,
      onPressed: () async {
        if (await Permission.camera.request().isGranted) {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (context) => ScanCameraPage()),
          );
        }
      },
    );
  }
}

class NoFAB extends StatelessWidget {
  const NoFAB({
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

class BottomAppBarWithFab extends StatelessWidget {
  const BottomAppBarWithFab({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
        elevation: 3.0,
        shape: CircularNotchedRectangle(),
        notchMargin: 5.0,
        color: Colors.white,
        child: Container(
            height: 60.0,
            width: double.infinity,
            child: Row(children: <Widget>[
              MaterialButton(
                  onPressed: () => context
                      .bloc<BottomNavigationBloc>()
                      .add(PageTapped(index: 0)),
                  shape: CircleBorder(
                      side: BorderSide(width: 1.0, color: Colors.transparent)),
                  textColor:
                      (context.bloc<BottomNavigationBloc>().currentIndex == 0)
                          ? Colors.blue
                          : Colors.blueGrey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FlutterIcons.home_mdi),
                        (context.bloc<BottomNavigationBloc>().currentIndex == 0)
                            ? Text("Home")
                            : Container(width: 0.0, height: 0.0),
                      ])),
              MaterialButton(
                  minWidth: 60.0,
                  padding: EdgeInsets.all(0),
                  onPressed: () => context
                      .bloc<BottomNavigationBloc>()
                      .add(PageTapped(index: 1)),
                  shape: CircleBorder(
                      side: BorderSide(width: 1.0, color: Colors.transparent)),
                  textColor:
                      (context.bloc<BottomNavigationBloc>().currentIndex == 1)
                          ? Colors.blue
                          : Colors.blueGrey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FlutterIcons.history_mdi),
                        (context.bloc<BottomNavigationBloc>().currentIndex == 1)
                            ? Text("History")
                            : Container(width: 0.0, height: 0.0),
                      ])),
              Spacer(),
              MaterialButton(
                  minWidth: 60.0,
                  padding: EdgeInsets.all(0),
                  onPressed: () => context
                      .bloc<BottomNavigationBloc>()
                      .add(PageTapped(index: 2)),
                  shape: CircleBorder(
                      side: BorderSide(width: 1.0, color: Colors.transparent)),
                  textColor:
                      (context.bloc<BottomNavigationBloc>().currentIndex == 2)
                          ? Colors.blue
                          : Colors.blueGrey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FlutterIcons.qrcode_edit_mco),
                        (context.bloc<BottomNavigationBloc>().currentIndex == 2)
                            ? Text("Create")
                            : Container(width: 0.0, height: 0.0),
                      ])),
              MaterialButton(
                  onPressed: () => context
                      .bloc<BottomNavigationBloc>()
                      .add(PageTapped(index: 3)),
                  shape: CircleBorder(
                      side: BorderSide(width: 1.0, color: Colors.transparent)),
                  textColor:
                      (context.bloc<BottomNavigationBloc>().currentIndex == 3)
                          ? Colors.blue
                          : Colors.blueGrey,
                  child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        Icon(FlutterIcons.settings_mdi),
                        (context.bloc<BottomNavigationBloc>().currentIndex == 3)
                            ? Text("Settings")
                            : Container(width: 0.0, height: 0.0),
                      ]))
            ])));
  }
}
