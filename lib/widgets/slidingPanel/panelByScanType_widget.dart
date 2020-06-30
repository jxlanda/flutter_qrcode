import 'package:flutter/material.dart';
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/widgets/iconByScanType_widget.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:qrcode/utils/utils.dart' as utils;
import 'package:qrcode/environment/environment.dart' as env;

class PanelByScanType extends StatelessWidget {
  final Scan scan;
  const PanelByScanType({Key key, @required this.scan}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    String type = '';
    if (scan != null) type = scan.type;
    final List<String> _listTypes = env.scanTypes.keys.toList();
    if (type == _listTypes[0]) return UrlPanel(type: type, scan: scan);
    if (type == _listTypes[1]) return WifiPanel(type: type, scan: scan);
    if (type == _listTypes[2]) return LocationPanel(type: type, scan: scan);
    if (type == _listTypes[3]) return EmailPanel(type: type, scan: scan);
    if (type == _listTypes[4]) return PhonePanel(type: type, scan: scan);
    if (type == _listTypes[5]) return SmsPanel(type: type, scan: scan);
    if (type == _listTypes[6]) return EventPanel(type: type, scan: scan);
    return TextPanel(type: type, scan: scan);
  }
}

class ListTilePanel extends StatelessWidget {
  const ListTilePanel({
    Key key,
    @required this.scan,
  }) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return ListTile(
      onTap: () => print("item"),
      leading: Container(
        padding: EdgeInsets.only(right: 15.0),
        decoration: BoxDecoration(
          border: Border(
            right: BorderSide(width: 1.0, color: Colors.black),
          ),
        ),
        child: IconByScanType(scanType: scan.type, color: Colors.black),
      ),
      title: Text(scan.value, overflow: TextOverflow.ellipsis, maxLines: 2),
    );
  }
}

class EventPanel extends StatelessWidget {
  const EventPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return ListTilePanel(scan: scan);
  }
}

class SmsPanel extends StatelessWidget {
  const SmsPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              LaunchButton(scan: scan)
            ],
          ),
        ),
      ],
    );
  }
}

class PhonePanel extends StatelessWidget {
  const PhonePanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              LaunchButton(scan: scan)
            ],
          ),
        ),
      ],
    );
  }
}

class EmailPanel extends StatelessWidget {
  const EmailPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              LaunchButton(scan: scan)
            ],
          ),
        ),
      ],
    );
  }
}

class LocationPanel extends StatelessWidget {
  const LocationPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              LaunchButton(scan: scan)
            ],
          ),
        ),
      ],
    );
  }
}

class WifiPanel extends StatelessWidget {
  const WifiPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    // Obtenemos los valores del tipo de scan
    final List<String> wifiList = utils.getCleanValueByScanType(scan: scan);

    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              ConnectButton(ssid: wifiList[0], password: wifiList[1]),
            ],
          ),
        ),
      ],
    );
  }
}

class UrlPanel extends StatelessWidget {
  const UrlPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              CopyButton(scan: scan),
              SizedBox(width: 10.0),
              LaunchButton(scan: scan)
            ],
          ),
        ),
      ],
    );
  }
}

class TextPanel extends StatelessWidget {
  const TextPanel({
    Key key,
    @required this.type,
    @required this.scan,
  }) : super(key: key);

  final String type;
  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        ListTilePanel(scan: scan),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: <Widget>[
              ShareButton(scan: scan),
              SizedBox(width: 10.0),
              CopyButton(scan: scan),
            ],
          ),
        ),
      ],
    );
  }
}