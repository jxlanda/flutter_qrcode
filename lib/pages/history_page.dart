import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:qrcode/environment/environment.dart' as env;
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/pages/pages.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:qrcode/utils/utils.dart' as utils;
// Plugins
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive/hive.dart';
import 'package:flutter_icons/flutter_icons.dart';

class HistoryPage extends StatelessWidget {
  const HistoryPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    print("Building history page ...");
    // Agregamos el QR a la base de datos
    // final Scan scan = new Scan(
    //     value:
    //         "It is a long established fact that a reader will be distracted by the readable content of a page when looking at its layout. The point of using Lorem Ipsum is that it has a more-or-less normal distribution of letters, as opposed to using",
    //     dateTime: DateTime.now());
    // // Asigmamos el scan creado al currentScan
    // final HiveDatabase database = new HiveDatabase();
    // database.addToDatabase(
    //     database: env.HiveHistory,
    //     record: scan,
    //     type: env.HiveTypes.Scan.toString());

    // SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
    SystemChrome.setSystemUIOverlayStyle(
        SystemUiOverlayStyle(statusBarColor: Colors.transparent));
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        centerTitle: true,
        elevation: 2.0,
      ),
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: Column(
          children: <Widget>[
            // Expanded(
            //   flex: 1,
            //   child: Row(
            //     children: <Widget>[
            //       SizedBox(width: 25.0),
            //       Text(
            //         "History",
            //         textScaleFactor: 1.5,
            //         style: TextStyle(color: Colors.blue),
            //       ),
            //     ],
            //   ),
            // ),
            SizedBox(
              height: 10.0,
            ),
            Expanded(
              flex: 9,
              child: ValueListenableBuilder(
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
                        elevation: 1.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                        margin: EdgeInsets.symmetric(
                            horizontal: 10.0, vertical: 4.0),
                        child: InkWell(
                          onTap: () => Navigator.of(context).push(
                            MaterialPageRoute(
                              builder: (context) => ScanDetailsPage(scan: scan),
                            ),
                          ),
                          child: CustomListItemTwo(scan: scan),
                        ),
                      );
                    },
                    itemCount: keys.length,
                  );
                },
              ),
            ),
          ],
        ),
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
      padding: EdgeInsets.only(right: 10.0),
      decoration: BoxDecoration(
        border: Border(
          right: BorderSide(width: 1.0, color: Colors.grey[700]),
        ),
      ),
      child: IconByScanType(scanType: scan.type, color: Colors.blue),
    );
  }
}

class SheetButton extends StatelessWidget {
  const SheetButton({Key key, @required this.scan}) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(10.0),
      onTap: () => utils.bottomSheet(context: context, scan: scan),
      child: Icon(FlutterIcons.dots_vertical_mco, color: Colors.grey[700]),
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
          IconTypeTile(scan: scan),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  ListTileByScanType(scan: scan),
                  SizedBox(height: 10.0),
                  Text(
                    utils.dateTimeToString(time: scan.dateTime, locale: 'es'),
                    style: TextStyle(color: Colors.grey[700]),
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
