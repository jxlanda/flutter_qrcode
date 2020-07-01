import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:hive/hive.dart';
import 'package:qrcode/environment/environment.dart' as env;
import 'package:qrcode/models/qr_model.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:qrcode/utils/utils.dart' as utils;

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building history page ...");
    return Scaffold(
      appBar: AppBar(title: Text("History"), centerTitle: true),
      backgroundColor: Colors.grey[150],
      body: ValueListenableBuilder(
        valueListenable: Hive.box<Scan>(env.HiveHistory).listenable(),
        builder: (BuildContext context, Box<Scan> box, Widget widget) {
          // Genera una lista de keys/values la base de datos: history
          List<int> keys = box.keys.cast<int>().toList();
          // Ordenamos los items por fecha
          keys.sort((a, b) => b.compareTo(a));
          // Si no hay valores
          if (keys.length == 0) return Center(child: Text("Empty"));
          // Si hay valores regresa una lista
          return ListView.builder(
              itemBuilder: (context, index) {
                // Regresa el scan actual
                final scan = box.get(keys[index]);
                return Card(
                  elevation: 0.5,
                  child: InkWell(
                    onTap: () => utils.showDialogByScanType(
                        context: context, scan: scan),
                    child: CustomListItemTwo(scan: scan),
                  ),
                );
              },
              itemCount: keys.length);
        },
      ),
    );
  }
}

class IconTypeTile extends StatelessWidget {
  const IconTypeTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: 15.0),
      decoration: BoxDecoration(
          color: Colors.red,
          border: Border(right: BorderSide(width: 1.0, color: Colors.black))),
      child: IconByScanType(scanType: scan.type, color: Colors.black),
    );
  }
}

class SheetButton extends StatelessWidget {
  const SheetButton({Key key, @required this.scan}) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 20.0,
      height: 20.0,
      child: Align(
        alignment: Alignment.topCenter,
        child: IconButton(
          padding: EdgeInsets.all(0),
          icon: Icon(FlutterIcons.dots_vertical_mco, color: Colors.black),
          onPressed: () => utils.bottomSheet(context: context, scan: scan),
        ),
      ),
    );
  }
}

class CustomListItemTwo extends StatelessWidget {
  CustomListItemTwo({Key key, @required this.scan}) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 15.0, horizontal: 10.0),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Container(
            padding: EdgeInsets.only(right: 15.0),
            decoration: BoxDecoration(
                border:
                    Border(right: BorderSide(width: 1.0, color: Colors.black))),
            child: IconByScanType(scanType: scan.type, color: Colors.black),
          ),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.only(left: 15.0, right: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTileByScanType(scan: scan),
                  SizedBox(height: 10.0),
                  Text(
                    utils.dateTimeToString(time: scan.dateTime, locale: 'es'),
                  )
                ],
              ),
            ),
          ),
          SheetButton(scan: scan),
        ],
      ),
    );
  }
}
