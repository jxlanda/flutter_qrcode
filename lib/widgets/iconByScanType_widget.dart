import 'package:flutter/material.dart';
import 'package:qrcode/environment/environment.dart' as env;

class IconByScanType extends StatelessWidget {
  final String scanType;
  final Color color;
  const IconByScanType({Key key, @required this.scanType, this.color = Colors.black }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Icon(env.scanTypes[scanType], color: color);
  }
}