import 'package:flutter/material.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:qrcode/environment/environment.dart';

class IconByScanType extends StatelessWidget {
  final String scanType;
  final Color color;
  const IconByScanType(
      {Key key, @required this.scanType, this.color = Colors.black})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    if (scanType == ScanTypes.url.value)
      return Icon(
        FlutterIcons.earth_mco,
        color: color,
      );
    if (scanType == ScanTypes.wifi.value)
      return Icon(
        FlutterIcons.wifi_mdi,
        color: color,
      );
    if (scanType == ScanTypes.location.value)
      return Icon(
        FlutterIcons.location_on_mdi,
        color: color,
      );
    if (scanType == ScanTypes.email.value)
      return Icon(
        FlutterIcons.email_mco,
        color: color,
      );
    if (scanType == ScanTypes.phone.value)
      return Icon(
        FlutterIcons.local_phone_mdi,
        color: color,
      );
    if (scanType == ScanTypes.sms.value)
      return Icon(
        FlutterIcons.textsms_mdi,
        color: color,
      );
    if (scanType == ScanTypes.event.value)
      return Icon(
        FlutterIcons.event_mdi,
        color: color,
      );
    return Icon(
      FlutterIcons.text_subject_mco,
      color: color,
    );
  }
}
