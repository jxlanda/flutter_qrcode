import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:qrcode/environment/environment.dart';
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/utils/utils.dart' as utils;

class ScanDetailsPage extends StatelessWidget {
  const ScanDetailsPage({Key key, @required this.scan}) : super(key: key);
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "QRCode Details",
          style: TextStyle(color: Colors.white),
        ),
        elevation: 0.0,
        centerTitle: true,
      ),
      backgroundColor: Theme.of(context).primaryColor,
      body: Column(
        children: <Widget>[
          QRImage(scan: scan),
          Expanded(child: ContentQR(scan: scan)),
        ],
      ),
    );
  }
}

class ContentQR extends StatelessWidget {
  const ContentQR({Key key, @required this.scan}) : super(key: key);
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: Theme.of(context).cardColor,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(25.0),
            topRight: Radius.circular(25.0),
          ),
          shape: BoxShape.rectangle),
      child: Column(
        children: <Widget>[
          Padding(
            padding:
                const EdgeInsets.symmetric(vertical: 10.0, horizontal: 15.0),
            child: Center(
              child: Text(
                "Details",
                textScaleFactor: 1.4,
              ),
            ),
          ),
          ContentByScanType(scan: scan),
          Spacer(),
          SaveQRButton(scan: scan),
        ],
      ),
    );
  }
}

class QRImage extends StatelessWidget {
  const QRImage({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 20.0),
      padding: EdgeInsets.all(10.0),
      // clipBehavior: Clip.antiAliasWithSaveLayer,
      decoration: BoxDecoration(
        color: Colors.white,
        // border: Border.all(color: Colors.grey[200]),
        borderRadius: BorderRadius.circular(10.0),
        shape: BoxShape.rectangle,
      ),
      child: QrImage(
        data: scan.value,
        version: QrVersions.auto,
        size: 200,
        gapless: false,
      ),
    );
  }
}

class _CopyContentButton extends StatelessWidget {
  const _CopyContentButton({Key key, @required this.text}) : super(key: key);

  final String text;

  @override
  Widget build(BuildContext context) {
    return IconButton(
      icon: Icon(FlutterIcons.content_copy_mdi),
      onPressed: () async {
        await utils.copyToClipBoard(text).then(
          (success) {
            success
                ? utils.showCustomSnackBar(context, "Copied to clipboard")
                : utils.showCustomSnackBar(context, "Could not copy");
          },
        );
      },
    );
  }
}

class SaveQRButton extends StatelessWidget {
  const SaveQRButton({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0),
      child: FlatButton(
        color: Theme.of(context).accentColor,
        colorBrightness: Theme.of(context).accentColorBrightness,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20.0),
        ),
        onPressed: () async {
          await utils.toQRImageData(scan.value).then((success) {
            success
                ? utils.showCustomSnackBar(context, "QRCode saved in gallery")
                : utils.showCustomSnackBar(context, "Could not save QRCode");
          });
        },
        child: Container(
          alignment: Alignment.center,
          child: Text(
            "SAVE QR CODE",
            textScaleFactor: 1.2,
          ),
        ),
      ),
    );
  }
}

class ContentByScanType extends StatelessWidget {
  const ContentByScanType({Key key, @required this.scan}) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    if (scan.type == ScanTypes.url.value) return UrlContent(scan: scan);
    if (scan.type == ScanTypes.wifi.value) return WifiContent(scan: scan);
    if (scan.type == ScanTypes.location.value)
      return LocationContent(scan: scan);
    if (scan.type == ScanTypes.email.value) return EmailContent(scan: scan);
    if (scan.type == ScanTypes.phone.value) return PhoneContent(scan: scan);
    if (scan.type == ScanTypes.sms.value) return SmsContent(scan: scan);
    if (scan.type == ScanTypes.text.value) return TextContent(scan: scan);
    return Container(width: 0.0, height: 0.0);
  }
}

class TextContent extends StatelessWidget {
  const TextContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("Text"),
          subtitle: Text(
            scan.value,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: scan.value),
        ),
      ],
    );
  }
}

class SmsContent extends StatelessWidget {
  const SmsContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> smsList = utils.getCleanValueByScanType(scan: scan);
    String phoneNumber = smsList[0];
    String body = smsList[1];
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("Phone Number"),
          subtitle: Text(
            phoneNumber,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: phoneNumber),
        ),
        ListTile(
          title: Text("Message"),
          subtitle: Text(
            body,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: body),
        ),
      ],
    );
  }
}

class PhoneContent extends StatelessWidget {
  const PhoneContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> phoneList = utils.getCleanValueByScanType(scan: scan);
    final String phoneNumber = phoneList[0];
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("Phone Number"),
          subtitle: Text(
            phoneNumber,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: phoneNumber),
        ),
      ],
    );
  }
}

class LocationContent extends StatelessWidget {
  const LocationContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> locationList = utils.getCleanValueByScanType(scan: scan);
    final String lat = locationList[0];
    final String lon = locationList[1];
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("Latitude"),
          subtitle: Text(
            lat,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: lat),
        ),
        ListTile(
          title: Text("Longitude"),
          subtitle: Text(
            lon,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: lon),
        ),
      ],
    );
  }
}

class WifiContent extends StatelessWidget {
  const WifiContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> wifiList = utils.getCleanValueByScanType(scan: scan);
    String ssid = wifiList[0];
    String password = wifiList[1];
    String encryption = wifiList[2];
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("SSID"),
          subtitle: Text(ssid),
          trailing: _CopyContentButton(text: ssid),
        ),
        ListTile(
          title: Text("Password"),
          subtitle: Text(password),
          trailing: _CopyContentButton(text: password),
        ),
        ListTile(
          title: Text("Encryption"),
          subtitle: Text(encryption),
          trailing: _CopyContentButton(text: encryption),
        ),
      ],
    );
  }
}

class UrlContent extends StatelessWidget {
  const UrlContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("URL"),
          subtitle: Text(
            scan.value,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(text: scan.value),
        ),
      ],
    );
  }
}

class EmailContent extends StatelessWidget {
  const EmailContent({Key key, @required this.scan}) : super(key: key);
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> _emailList = utils.getCleanValueByScanType(scan: scan);
    String _email = _emailList[0];
    String _subject = _emailList[1];
    String _body = _emailList[2];

    return Wrap(
      children: <Widget>[
        ListTile(
          title: Text("Email"),
          subtitle: Text(
            _email,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(
            text: _email,
          ),
        ),
        ListTile(
          title: Text("Subject"),
          subtitle: Text(
            _subject,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(
            text: _subject,
          ),
        ),
        ListTile(
          title: Text("Message"),
          subtitle: Text(
            _body,
            textAlign: TextAlign.justify,
          ),
          trailing: _CopyContentButton(
            text: _body,
          ),
        ),
      ],
    );
  }
}
