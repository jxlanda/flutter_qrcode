// Base de datos
const String HiveHistory = 'history';
const String HiveSettings = 'settings';
enum HiveTypes { Scan, Settings }

extension HiveTypesExtension on HiveTypes {
  static String _value(HiveTypes val) {
    switch (val) {
      case HiveTypes.Scan:
        return "scan";
      case HiveTypes.Settings:
        return "settings";
      default:
        return "scan";
    }
  }

  String get value => _value(this);
}

// QR Scan

const flashOn = 'FLASH ON';
const flashOff = 'FLASH OFF';
const frontCamera = 'FRONT CAMERA';
const backCamera = 'BACK CAMERA';

// Constantes
enum ScanTypes { url, wifi, location, email, phone, sms, text }

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
      case ScanTypes.text:
        return "text";
      default:
        return "text";
    }
  }

  String get value => _value(this);
}
