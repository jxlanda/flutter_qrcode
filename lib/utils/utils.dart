import 'dart:io';
import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:image_gallery_saver/image_gallery_saver.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/repositories/hivedb_repository.dart';
import 'package:share_extend/share_extend.dart';
import 'package:timeago/timeago.dart' as timeAgo;
import 'package:url_launcher/url_launcher.dart';
import 'package:wifi_connector/wifi_connector.dart';

List<String> getCleanValueByScanType({Scan scan}) {
  if (scan.type == ScanTypes.url.value) return [scan.value];
  if (scan.type == ScanTypes.wifi.value) return wifiList(scan);
  if (scan.type == ScanTypes.location.value) return locationList(scan);
  if (scan.type == ScanTypes.email.value) return emailList(scan);
  if (scan.type == ScanTypes.phone.value) return phoneList(scan);
  if (scan.type == ScanTypes.sms.value)
    return smsList(scan);
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

// Convierte los campos String al formato de lectura QR

String wifiFieldsToQRFormat({String ssid, String password, String encryption}) {
  if (encryption.isEmpty) {
    encryption = "UNKNOWN";
  }
  // Patron WIFI:T:WPA;P:jf234lsfjlsdjf;S:LANDA;
  final String wifiDataFormat = "WIFI:S:$ssid;P:$password;T:$encryption;";
  return wifiDataFormat;
}

String locationFieldsToQRFormat({String latitude, String longitude}) {
  // Patron: geo:<lat>,<lon>
  String locationDataFormat = "geo:$latitude,$longitude";
  return locationDataFormat;
}

String emailFieldsToQRFormat({String email, String subject, String body}) {
  // Patron: mailto:email@gmail.com?subject=tema&body=mensaje
  // ? significa que pueden venir o no
  if (subject.isNotEmpty) {
    subject = '?subject=$subject';
  }
  if (body.isNotEmpty) {
    body = '&body=$body';
  }
  String emailDataFormat = 'mailto:$email$subject$body';
  return emailDataFormat;
}

String phoneFieldsToQRFormat({String phoneNumber}) {
  // Patron: tel:6641234567
  String phoneDataFormat = 'tel:$phoneNumber';
  return phoneDataFormat;
}

String smsFieldsToQRFormat({String phoneNumber, String body}) {
  // Patron: SMSTO:6641234567:contenido
  String smsDataFormat = 'SMSTO:$phoneNumber:$body';
  return smsDataFormat;
}

Future<void> launchURL(
    {BuildContext context, Scan scan, ScaffoldState scaffoldState}) async {
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
  } else {
    snackBar(
        scaffoldState: scaffoldState,
        text: 'Could not launch',
        duration: Duration(seconds: 2));
  }
}

Future<bool> connectWifi(
    {BuildContext context, String ssid, String password}) async {
  final scaffold = Scaffold.of(context);
  final bool isSuccess =
      await WifiConnector.connectToWifi(ssid: ssid, password: password);
  isSuccess
      ? snackBar(scaffoldState: scaffold, text: 'Connecting to: $ssid')
      : snackBar(scaffoldState: scaffold, text: 'Cannot connect to: $ssid');
  return isSuccess;
}

String dateTimeToString({DateTime time, String locale}) {
  return timeAgo.format(time, locale: locale);
}

void snackBar({
  ScaffoldState scaffoldState,
  String text,
  SnackBarAction action,
  Duration duration,
}) {
  if (duration == null) duration = Duration(seconds: 3);
  scaffoldState.showSnackBar(
    SnackBar(content: Text(text), action: action, duration: duration),
  );
}

void showCustomSnackBar(BuildContext context, String message,
    {SnackBarAction action,
    Duration duration,
    Color backColor,
    IconData icon}) {
  final scaffold = Scaffold.of(context);
  if (duration == null) duration = Duration(seconds: 3);
  // Oculta el snackbar actual
  scaffold..hideCurrentSnackBar();
  // Muestra el nuevo snackbar
  scaffold.showSnackBar(
    SnackBar(
      content: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Container(
            child: (icon == null)
                ? Container(
                    width: 0.0,
                    height: 0.0,
                  )
                : Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: Icon(icon),
                  ),
          ),
          Text(message),
        ],
      ),
      action: action,
      duration: duration,
      backgroundColor: backColor,
    ),
  );
}

Future<bool> copyToClipBoard(String textToCopy) async {
  await Clipboard.setData(ClipboardData(text: textToCopy));
  return true;
}

void shareText(String text) {
  ShareExtend.share(text, 'text');
}

Future<void> shareQRImage(String qrdata) async {
  final File qrImage = await createQRData(qrdata);
  ShareExtend.share(qrImage.path, "file");
}

Future<File> createQRData(String qrdata) async {
  final ByteData image = await QrPainter(
    data: qrdata,
    version: QrVersions.auto,
    emptyColor: Colors.white,
    gapless: false,
  ).toImageData(250);
  Uint8List pngBytes = image.buffer.asUint8List();
  //  Guardar imagen en un directorio temporal
  final String tempDir = (await getTemporaryDirectory()).path;
  final File qrcodeFile = File('$tempDir/qr_code.png');
  await qrcodeFile.writeAsBytes(pngBytes);
  return qrcodeFile;
}

Future<bool> toQRImageData(String qrCode, {Color color = Colors.black}) async {
  final ByteData image = await QrPainter(
          data: qrCode,
          version: QrVersions.auto,
          color: color,
          emptyColor: Colors.white,
          gapless: false)
      .toImageData(300);
  Uint8List pngBytes = image.buffer.asUint8List();
  // String bs64 = base64Encode(pngBytes);

  //  Save image to data/com.example.qrcode/files/qr_code.png
  final tempDir = (await getTemporaryDirectory()).path;
  final qrcodeFile = File('$tempDir/qr_code.png');
  await qrcodeFile.writeAsBytes(pngBytes);

  // Permission handler
  if (await Permission.storage.request().isGranted) {
    await ImageGallerySaver.saveFile(qrcodeFile.path);
    return true;
    // openAppSettings();
  }
  return false;
}

void bottomSheet({BuildContext context, Scan scan}) {
  final scaffold = Scaffold.of(context);
  final HiveDatabase database = new HiveDatabase();
  final int scanKey = scan.key;
  List<Widget> tilesByScanType = [];

  // ListTiles generales
  ListTile shareListTile = ListTile(
    leading: Icon(FlutterIcons.share_mdi),
    title: Text('Share'),
    onTap: () {
      shareQRImage(scan.value);
      Navigator.pop(context);
    },
  );
  // Permite copiar al portapapeles
  ListTile copyListTile = ListTile(
    leading: Icon(FlutterIcons.content_copy_mdi),
    title: Text('Copy'),
    onTap: () async {
      await copyToClipBoard(scan.value).then(
        (success) {
          success
              ? showCustomSnackBar(context, "Copied to clipboard")
              : showCustomSnackBar(context, "Could not copy");
        },
      );
      Navigator.pop(context);
    },
  );
  // Permite conectar al WIFI
  ListTile connectListTile = ListTile(
    leading: Icon(FlutterIcons.wifi_tethering_mdi),
    title: Text('Connect'),
    onTap: () async {
      // Obtenemos los valores del tipo de scan
      final List<String> wifiList = getCleanValueByScanType(scan: scan);
      final String ssid = wifiList[0];
      final String password = wifiList[1];
      await connectWifi(context: context, ssid: ssid, password: password);
      Navigator.pop(context);
    },
  );
  // Abre la aplicacion segun el tipo de scan
  ListTile launchListTile = ListTile(
    leading: Icon(FlutterIcons.launch_mdi),
    title: Text('Launch'),
    onTap: () {
      launchURL(context: context, scan: scan, scaffoldState: scaffold);
      Navigator.pop(context);
    },
  );
  // Elimina el scan de la base de datos
  ListTile removeListTile = ListTile(
    leading: Icon(FlutterIcons.trash_can_mco),
    title: Text('Remove'),
    onTap: () async {
      await database.removeFromDatabase(
          database: HiveHistory,
          key: scan.key,
          type: HiveTypes.Scan.toString());
      Navigator.pop(context);
      snackBar(
        scaffoldState: scaffold,
        text: "Removed from history",
        action: SnackBarAction(
          label: "Undo",
          onPressed: () async {
            database.updateFromDatabase(
                database: HiveHistory,
                record: scan,
                key: scanKey,
                type: HiveTypes.Scan.toString());
          },
        ),
      );
    },
  );

  // Compruba el tipo de scan y asigna los listTiles correspondientes
  if (scan.type == ScanTypes.url.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      launchListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.wifi.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      connectListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.location.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      launchListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.email.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      launchListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.phone.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      launchListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.sms.value)
    tilesByScanType = [
      shareListTile,
      copyListTile,
      launchListTile,
      Divider(),
      removeListTile
    ];
  if (scan.type == ScanTypes.text.value)
    tilesByScanType = [shareListTile, copyListTile, Divider(), removeListTile];
  // Lanza el modal
  showModalBottomSheet(
    context: context,
    builder: (BuildContext context) {
      return Container(
        child: Wrap(
          children: tilesByScanType,
        ),
      );
    },
  );
}

// Extencion de la clase String que permite capitalizar el texto
extension StringExtension on String {
  String capitalize() {
    return "${this[0].toUpperCase()}${this.substring(1)}";
  }
}
