import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:qrcode/environment/environment.dart' as env;
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/repositories/hivedb_repository.dart';
import 'package:share/share.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_connector/wifi_connector.dart';

List<String> getCleanValueByScanType({Scan scan}) {
  final List<String> _listTypes = env.scanTypes.keys.toList();
  if (scan.type == _listTypes[0]) return ["url", scan.value];
  if (scan.type == _listTypes[1]) return wifiList(scan);
  if (scan.type == _listTypes[2]) return locationList(scan);
  if (scan.type == _listTypes[3]) return emailList(scan);
  if (scan.type == _listTypes[4]) return phoneList(scan);
  if (scan.type == _listTypes[5]) return smsList(scan);
  if (scan.type == _listTypes[6])
    return ["event"];
  else
    return [scan.value];
}

List<String> wifiList(Scan scan) {
  // Patron: WIFI:S:ssidname;T:wpa;P:password;;
  // o WIFI:T:WPA;P:7adJHoaPCNt2GbS;S:LANDA;
  String ssid = '';
  String encription = '';
  String password = '';
  // Quitamos WIFI: al scan.value
  final String cleanValue = scan.value.split("WIFI:").last;
  List<String> splitValue = cleanValue.split(";");
  splitValue.forEach((element) {
    // Resultado: ssidname
    if (element.contains("S:")) ssid = element.split("S:").last;
    // Resultado: passwod
    if (element.contains("P:")) password = element.split("P:").last;
    // Resultado: wpa
    if (element.contains("T:")) encription = element.split("T:").last;
  });

  return [ssid, password, encription];
}

List<String> phoneList(Scan scan) {
  // Patron: tel:6641234567
  final List<String> splitValue = scan.value.split("tel:");
  // Resultado: tel:, 6641234567
  final String phoneNumber = splitValue.last;
  return [phoneNumber];
}

List<String> emailList(Scan scan) {
  // Patron: mailto:email@gmail.com?subject=tema&body=mensaje
  // ? significa que pueden venir o no

  String email = "";
  String subject = "";
  String body = "";

  List<String> splitValue = [];
  // Dividimos el email y contenido por ?
  List<String> splitMail = scan.value.split("?");
  // Agregamos el email  a la lista final
  splitValue.add(splitMail.first);
  //  Verificamos si tiene body [0] email, [1] subject+body
  if (splitMail.length >= 2) {
    // Separamos el body del subject por &
    final List<String> splitBody = splitMail[1].split("&");
    // Agregamos los valores a la lista final
    splitValue.addAll(splitBody);
  }
  // Recorre cada string del arreglo
  splitValue.forEach((element) {
    if (element.contains("mailto")) email = element.split("mailto:").last;
    if (element.contains("subject")) subject = element.split("subject=").last;
    if (element.contains("body")) body = element.split("body=").last;
  });

  return [email, subject, body];
}

List<String> smsList(Scan scan) {
  // Patron: SMSTO:6641234567:contenido
  String phoneNumber = "";
  String body = "";
  List<String> splitValue = scan.value.split(":");
  phoneNumber = splitValue[1];
  body = splitValue[2];
  return [phoneNumber, body];
}

List<String> locationList(Scan scan) {
  // Patron: geo:<lat>,<lon>
  // Google Maps https://maps.google.com/local?q=50.38147410289163,7.410235000000003
  String lat = "";
  String lon = "";
  List<String> splitValue = scan.value.split(",");
  if (splitValue[0].startsWith("http")) {
    lat = splitValue[0].split("q=").last;
  } else {
    // Quitamos geo: de geo:<lat>
    lat = splitValue[0].split("geo:").last;
  }
  // Resultado: <lon>
  lon = splitValue[1];
  return [lat, lon];
}

Future<void> launchUri(String uri) async {
  await launch(uri);
}

Future<void> launchURL({BuildContext context, Scan scan}) async {
  if (scan.type == "location") {
    List<String> locationTemp = locationList(scan);
    String lat = locationTemp[0];
    String lon = locationTemp[1];
    final String locationFormat = "geo:$lat,$lon";
    await launch(locationFormat);
    return;
  } else if (await canLaunch(scan.value)) {
    await launch(scan.value);
    return;
  } else if (scan.value.startsWith("SMSTO")) {
    // Android
    // Formato 'sms:+39348060888?body=contenido';
    List<String> smsTemp = smsList(scan);
    final String phoneNumber = smsTemp[0];
    final String body = smsTemp[1];
    final Uri smsFormat =
        Uri(scheme: 'sms', path: phoneNumber, queryParameters: {'body': body});
    print(smsFormat);
    await launch(smsFormat.toString());
    return;
  } else
    print('Could not launch');
}

Future<void> connectWifi(
    {BuildContext context, String ssid, String password}) async {
  final scaffold = Scaffold.of(context);
  await WifiConnector.connectToWifi(ssid: ssid, password: password);
  snackBar(scaffoldState: scaffold, text: 'Connected to: $ssid');
}

void snackBar(
    {ScaffoldState scaffoldState, String text, SnackBarAction action}) {
  scaffoldState.showSnackBar(SnackBar(content: Text(text), action: action));
}

void shareModal(String text) {
  Share.share(text);
}

void clipBoard({BuildContext context, String text}) {
  final scaffold = Scaffold.of(context);
  Clipboard.setData(ClipboardData(text: text)).then(
      (_) => snackBar(scaffoldState: scaffold, text: 'Copied to Clipboard'));
}

void bottomSheet({BuildContext context, Scan scan}) {
  final scaffold = Scaffold.of(context);
  final HiveDatabase database = new HiveDatabase();
  final int scanKey = scan.key;

  showModalBottomSheet(
      context: context,
      builder: (BuildContext context) {
        return Container(
          child: Wrap(
            children: <Widget>[
              ListTile(
                  leading: Icon(FlutterIcons.share_mdi),
                  title: Text('Compartir'),
                  onTap: () {
                    shareModal(scan.value);
                    Navigator.pop(context);
                  }),
              ListTile(
                  leading: Icon(FlutterIcons.trash_can_mco),
                  title: Text('Remove'),
                  onTap: () async {
                    await database.removeFromDatabase(
                        database: env.HiveHistory,
                        key: scan.key,
                        type: env.HiveTypes.Scan.toString());
                    Navigator.pop(context);
                    snackBar(
                        scaffoldState: scaffold,
                        text: "Removed from history",
                        action: SnackBarAction(
                            label: "Undo",
                            onPressed: () async {
                              database.updateFromDatabase(
                                  database: env.HiveHistory,
                                  record: scan,
                                  key: scanKey,
                                  type: env.HiveTypes.Scan.toString());
                            }));
                  }),
              Divider(),
              ListTile(
                  leading: Icon(FlutterIcons.close_mdi),
                  title: Text('Cerrar'),
                  onTap: () => {Navigator.pop(context)}),
            ],
          ),
        );
      });
}

String dateTimeToString({DateTime time, String locale}) {
  return timeAgo.format(time, locale: locale);
}
