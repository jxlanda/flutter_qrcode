import 'package:flutter/material.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/environment/environment.dart' as env;
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:qrcode/repositories/hivedb_repository.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
// import 'package:qrcode/models/qr_model.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = '';
  bool flash = false;
  bool camera = false;
  QRViewController qrController;
  // PanelController panelController;
  // Scan currentScan;
  // double panelMinHeight = 0.0;
  // double panelExpandedMinHeight = 62.0;
  // bool isConnectingWifi = false;

  CameraBloc()
      : super(ScanCameraState(
            flash: env.flashOff, camera: env.backCamera, foundQR: false));

  @override
  Future<void> close() {
    qrController.dispose();
    return super.close();
  }

  @override
  Stream<CameraState> mapEventToState(CameraEvent event) async* {
    final scanState = state as ScanCameraState;
    if (event is ToggleFlash) {
      if (event.flash)
        yield scanState.copyWith(flash: env.flashOn);
      else
        yield scanState.copyWith(flash: env.flashOff);
      flash = !flash;
      qrController.toggleFlash();
    }
    if (event is ToggleCamera) {
      if (event.camera)
        yield scanState.copyWith(camera: env.frontCamera);
      else
        yield scanState.copyWith(camera: env.backCamera);
      camera = !camera;
      qrController.flipCamera();
    }
    if (event is QRViewCreated) qrController = event.qrViewController;
    // if (event is NotFoundQR) yield scanState.copyWith(foundQR: false);
    // if (event is FoundQR) {
    //   panelController = event.panelController;
    //   // Asigmanos el valor del evento
    //   qrText = event.qr;
    //   // Mostramos el slidingPanel
    //   panelMinHeight = panelExpandedMinHeight;
    //   // Expandimos al maximo el slidingPanel
    //   panelController.open();
    //   // Agregamos el QR a la base de datos
    //   final Scan scan = new Scan(value: event.qr, dateTime: DateTime.now());
    //   // Asigmamos el scan creado al currentScan
    //   currentScan = scan;
    //   final HiveDatabase database = new HiveDatabase();
    //   await database.addToDatabase(
    //       database: env.HiveHistory,
    //       record: scan,
    //       type: env.HiveTypes.Scan.toString());
    //   // Cambiamos las propiedasdes del state
    //   yield scanState.copyWith(foundQR: true);
    // }
    // if (event is ConnectWifi) {
    //   // Asignamos el estado de conexion a la variable local
    //   isConnectingWifi = event.isConnecting;
    //   // Reconstruimos la interfaz
    //   yield scanState.copyWith(isConnectingWifi: isConnectingWifi);
    // }
  }
}
