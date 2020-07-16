import 'package:flutter/material.dart';
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
    return Scaffold(
      appBar: AppBar(
        title: Text("History"),
        centerTitle: true,
        elevation: 0.0,
      ),
      backgroundColor: Theme.of(context).backgroundColor,
      body: Column(
        children: <Widget>[
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
                      margin:
                          EdgeInsets.only(left: 10.0, right: 10.0, top: 10.0),
                      child: InkWell(
                        onTap: () => Navigator.of(context).push(
                          MaterialPageRoute(
                            builder: (context) => ScanDetailsPage(scan: scan),
                          ),
                        ),
                        child: CustomCardContent(scan: scan),
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
          right: BorderSide(width: 1.0, color: Theme.of(context).dividerColor),
        ),
      ),
      child: IconByScanType(
        scanType: scan.type,
        color: Theme.of(context).accentColor,
      ),
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
      child: Icon(
        FlutterIcons.dots_vertical_mco,
        color: Theme.of(context).dividerColor,
      ),
    );
  }
}

class CustomCardContent extends StatelessWidget {
  CustomCardContent({Key key, @required this.scan}) : super(key: key);

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
                    style: TextStyle(color: Theme.of(context).dividerColor),
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
