import 'dart:convert';
import 'package:hive/hive.dart';
import 'package:qrcode/environment/environment.dart';
// Escribir el nombre del modelo a generar
part 'qr_model.g.dart';

// To parse this JSON data, do
//
//     final scan = scanFromJson(jsonString);

Scan scanFromJson(String str) => Scan.fromJson(json.decode(str));
String scanToJson(Scan data) => json.encode(data.toJson());

// Crear adapter
// Escribir @HiveType con su typeId: numeroConsecutivo
// Extender de HiveObject para tener .Save(), .Delete()
// Para generar el adapter correr: flutter packages pub run build_runner build
@HiveType(typeId: 0)
class Scan extends HiveObject {
  // Colocar @HiveField a cada campo
  @HiveField(0)
  String value;
  @HiveField(1)
  String type;
  @HiveField(2)
  DateTime dateTime;

  Scan({this.type, this.value, this.dateTime}) {
    // Los primeros cuatro caracteres del value
    String valueSubs = value.substring(0, 4);
    // Asignamos un tipo segun el substring
    switch (valueSubs) {
      case "http":
        if (value.contains("maps.google"))
          type = ScanTypes.location.value; // location
        else
          type = ScanTypes.url.value; // url
        break;
      case "WIFI":
        type = ScanTypes.wifi.value;
        break;
      case "geo:":
        type = ScanTypes.location.value; // location
        break;
      case "mail":
        type = ScanTypes.email.value; // email
        break;
      case "tel:":
        type = ScanTypes.phone.value; // phone
        break;
      case "SMST":
        type = ScanTypes.sms.value; // sms
        break;
      case "BEGI":
        type = ScanTypes.event.value; // event
        break;
      default:
        type = ScanTypes.text.value; // text
        break;
    }
  }

  factory Scan.fromJson(Map<String, dynamic> json) => Scan(
        type: json["type"] == null ? null : json["type"],
        value: json["value"] == null ? null : json["value"],
        dateTime: DateTime.parse(json["dateTime"]),
      );

  Map<String, dynamic> toJson() => {
        "type": type == null ? null : type,
        "value": value == null ? null : value,
        "dateTime": dateTime.toIso8601String(),
      };
}
