import 'package:flutter/material.dart';
import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/environment/environment.dart' as env;
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';

class CameraBloc extends Bloc<CameraEvent, CameraState> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  String qrText = '';
  bool flash = false;
  bool camera = false;
  QRViewController qrController;

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
  }
}
