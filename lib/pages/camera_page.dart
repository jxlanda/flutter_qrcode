import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_icons/flutter_icons.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/widgets/slidingPanel/panelByScanType_widget.dart';
import 'package:qrcode/widgets/widgets.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

// SystemChrome.setEnabledSystemUIOverlays(SystemUiOverlay.values);
// SystemChrome.setSystemUIOverlayStyle(
//   SystemUiOverlayStyle(
//     systemNavigationBarIconBrightness: Brightness.dark,
//     systemNavigationBarColor: Colors.white
//   )
// );

class ScanCameraPage extends StatelessWidget {
  const ScanCameraPage({Key key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    PanelController _panelController = new PanelController();
    return BlocProvider(
      create: (context) => CameraBloc(),
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
        ),
        extendBodyBehindAppBar: true,
        extendBody: true,
        body: BlocBuilder<CameraBloc, CameraState>(
          builder: (context, state) {
            if (state is ScanCameraState) {
              return Stack(
                children: <Widget>[
                  QRView(
                    key: context.bloc<CameraBloc>().qrKey,
                    onQRViewCreated: (QRViewController qrcontroller) {
                      context
                          .bloc<CameraBloc>()
                          .add(QRViewCreated(qrViewController: qrcontroller));
                      qrcontroller.scannedDataStream.listen(
                        (scanData) {
                          if (context.bloc<CameraBloc>().qrText != scanData) {
                            context.bloc<CameraBloc>().add(FoundQR(
                                panelController: _panelController,
                                qr: scanData));
                          } else
                            context.bloc<CameraBloc>().add(
                                NotFoundQR(panelController: _panelController));
                        },
                      );
                    },
                    overlay: QrScannerOverlayShape(
                        borderColor: Colors.blue,
                        borderRadius: 20,
                        borderLength: 25,
                        borderWidth: 10,
                        cutOutSize: 250),
                  ),
                  CameraButtons(panelController: _panelController),
                ],
              );
            }
            return Container(width: 0.0, height: 0.0);
          },
        ),
      ),
    );
  }
}

class CameraButtons extends StatelessWidget {
  const CameraButtons({
    Key key,
    @required PanelController panelController,
  })  : _panelController = panelController,
        super(key: key);

  final PanelController _panelController;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: <Widget>[
        Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            RawMaterialButton(
              onPressed: () => context.bloc<CameraBloc>().add(
                  ToggleCamera(camera: !context.bloc<CameraBloc>().camera)),
              elevation: 0.0,
              fillColor: context.bloc<CameraBloc>().camera
                  ? Colors.white
                  : Colors.white54,
              child: context.bloc<CameraBloc>().camera
                  ? Icon(FlutterIcons.sync_mdi, color: Colors.black)
                  : Icon(FlutterIcons.sync_mdi, color: Colors.black87),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            ),
            SizedBox(
              height: 70.0,
              width: 70.0,
              child: FloatingActionButton(
                  child: Icon(FlutterIcons.filter_center_focus_mdi,
                      color: Colors.black87),
                  backgroundColor: Colors.white54,
                  elevation: 0.0,
                  onPressed: () {}),
            ),
            RawMaterialButton(
              onPressed: () => context
                  .bloc<CameraBloc>()
                  .add(ToggleFlash(flash: !context.bloc<CameraBloc>().flash)),
              elevation: 0.0,
              fillColor: context.bloc<CameraBloc>().flash
                  ? Colors.white
                  : Colors.white54,
              child: context.bloc<CameraBloc>().flash
                  ? Icon(FlutterIcons.flashlight_off_mco, color: Colors.black)
                  : Icon(FlutterIcons.flashlight_mco, color: Colors.black87),
              padding: EdgeInsets.all(10.0),
              shape: CircleBorder(),
            )
          ],
        ),
        SizedBox(height: 20.0),
        SlidingUpPanel(
          controller: _panelController,
          maxHeight: 150.0,
          minHeight: context.bloc<CameraBloc>().panelMinHeight,
          panel: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Container(
                  width: 30,
                  height: 5,
                  decoration: BoxDecoration(
                    color: Colors.grey[300],
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                  ),
                ),
                Expanded(
                  child: PanelByScanType(
                      scan: context.bloc<CameraBloc>().currentScan),
                )
              ],
            ),
          ),
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(24.0),
            topRight: Radius.circular(24.0),
          ),
        )
      ],
    );
  }
}
