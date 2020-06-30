import 'package:flutter_icons/flutter_icons.dart';

// Constantes
// Asignamos un icono al tipo de QR Code
const Map<String, dynamic> scanTypes = {
  'url': FlutterIcons.earth_mco,
  'wifi': FlutterIcons.wifi_mdi,
  'location': FlutterIcons.location_on_mdi,
  'email': FlutterIcons.email_mco,
  'phone': FlutterIcons.local_phone_mdi,
  'sms': FlutterIcons.textsms_mdi,
  'event': FlutterIcons.event_mdi,
  'text': FlutterIcons.text_subject_mco
};

// Base de datos
const String HiveHistory = 'history';
enum HiveTypes { Scan, Settings }

// QR Scan

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

enum ScanTypes { url, wifi, location, email, phone, sms, event, text }

extension ScanTypesExtension on ScanTypes {
  static String _value(ScanTypes val) {
    switch (val) {
      case ScanTypes.url:
        return "url";
      case ScanTypes.wifi:
        return "wifi";
      case ScanTypes.location:
        return "location";
      case ScanTypes.email:
        return "email";
      case ScanTypes.phone:
        return "phone";
      case ScanTypes.sms:
        return "sms";
      case ScanTypes.event:
        return "event";
      case ScanTypes.text:
        return "text";
      default:
        return "text";
    }
  }

  String get value => _value(this);
}
