import 'package:flutter/material.dart';
import 'package:qrcode/environment/environment.dart' as env;
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/utils/utils.dart' as utils;

class ListTileByScanType extends StatelessWidget {
  const ListTileByScanType({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    final String type = scan.type;
    final List<String> _listTypes = env.scanTypes.keys.toList();
    if (type == _listTypes[0]) return UrlListTile(scan: scan);
    if (type == _listTypes[1]) return WifiListTile(scan: scan);
    if (type == _listTypes[2]) return LocationListTile(scan: scan);
    if (type == _listTypes[3]) return EmailListTile(scan: scan);
    if (type == _listTypes[4]) return PhoneListTile(scan: scan);
    if (type == _listTypes[5]) return SmsListTile(scan: scan);
    if (type == _listTypes[6]) return EventListTile(scan: scan);
    return TextListTile(scan: scan);
  }
}

class EventListTile extends StatelessWidget {
  const EventListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Text(scan.value,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify);
  }
}

class SmsListTile extends StatelessWidget {
  const SmsListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> smsList = utils.getCleanValueByScanType(scan: scan);

    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text("Phone Number: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(smsList[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(
          children: <Widget>[
            Text("Text: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(smsList[1],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify))
          ],
        ),
      ],
    );
  }
}

class PhoneListTile extends StatelessWidget {
  const PhoneListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> phoneList = utils.getCleanValueByScanType(scan: scan);

    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Text("Phone Number: ",
                style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(phoneList[0],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify))
          ],
        ),
      ],
    );
  }
}

class EmailListTile extends StatelessWidget {
  const EmailListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> emailList = utils.getCleanValueByScanType(scan: scan);

    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text("Email: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(emailList[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(children: <Widget>[
          Text("Subject: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(emailList[1],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(
          children: <Widget>[
            Text("Body: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(emailList[2],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify))
          ],
        ),
      ],
    );
  }
}

class LocationListTile extends StatelessWidget {
  const LocationListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> locationList = utils.getCleanValueByScanType(scan: scan);
    print(locationList);
    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text("Latitude: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(locationList[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(children: <Widget>[
          Text("Longitude: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(locationList[1],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
      ],
    );
  }
}

class WifiListTile extends StatelessWidget {
  const WifiListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> wifiList = utils.getCleanValueByScanType(scan: scan);

    return Column(
      children: <Widget>[
        Row(children: <Widget>[
          Text("SSID: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(wifiList[0],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(children: <Widget>[
          Text("Password: ", style: TextStyle(fontWeight: FontWeight.bold)),
          Expanded(
              child: Text(wifiList[1],
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.justify))
        ]),
        Row(
          children: <Widget>[
            Text("Encryption: ", style: TextStyle(fontWeight: FontWeight.bold)),
            Expanded(
                child: Text(wifiList[2],
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    textAlign: TextAlign.justify))
          ],
        ),
      ],
    );
  }
}

class UrlListTile extends StatelessWidget {
  const UrlListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Text(scan.value,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify);
  }
}

class TextListTile extends StatelessWidget {
  const TextListTile({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Text(scan.value,
        maxLines: 3,
        overflow: TextOverflow.ellipsis,
        textAlign: TextAlign.justify);
  }
}
