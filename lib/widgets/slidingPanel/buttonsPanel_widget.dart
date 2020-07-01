import 'package:flutter/material.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/models/qr_model.dart';
import 'package:qrcode/utils/utils.dart' as utils;
// Plugins
import 'package:flutter_icons/flutter_icons.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class LaunchButton extends StatelessWidget {
  const LaunchButton({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      shape:
          RoundedRectangleBorder(borderRadius: new BorderRadius.circular(30.0)),
      color: Colors.blue,
      onPressed: () => utils.launchURL(context: context, scan: scan),
      icon: Icon(FlutterIcons.launch_mdi),
      label: Text("Launch"),
    );
  }
}

class ShareButton extends StatelessWidget {
  const ShareButton({Key key, @required this.scan}) : super(key: key);
  final Scan scan;
  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: Colors.blue,
      onPressed: () => utils.shareModal(scan.value),
      icon: Icon(FlutterIcons.share_mdi),
      label: Text("Share"),
    );
  }
}

class CopyButton extends StatelessWidget {
  const CopyButton({Key key, @required this.scan}) : super(key: key);

  final Scan scan;

  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: Colors.blue,
      onPressed: () => utils.clipBoard(context: context, text: scan.value),
      icon: Icon(FlutterIcons.content_copy_mdi),
      label: Text("Copy"),
    );
  }
}

class ConnectButton extends StatelessWidget {
  const ConnectButton({Key key, @required this.ssid, @required this.password})
      : super(key: key);

  final String ssid;
  final String password;

  @override
  Widget build(BuildContext context) {
    return OutlineButton.icon(
      shape: RoundedRectangleBorder(
        borderRadius: new BorderRadius.circular(30.0),
      ),
      color: Colors.blue,
      onPressed: context.bloc<CameraBloc>().isConnectingWifi
          ? null
          : () async {
              context.bloc<CameraBloc>().add(ConnectWifi(isConnecting: true));
              await utils.connectWifi(
                  context: context, ssid: ssid, password: password);
              context.bloc<CameraBloc>().add(ConnectWifi(isConnecting: false));
            },
      icon: Icon(FlutterIcons.wifi_tethering_mdi),
      label: Text("Connect"),
    );
  }
}
