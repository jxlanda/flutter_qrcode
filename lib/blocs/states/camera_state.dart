import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CameraState extends Equatable {
  const CameraState();

  @override
  List<Object> get props => [];
}

class ScanCameraState extends CameraState {
  final String flash;
  final String camera;
  final bool foundQR;
  final bool isConnectingWifi;

  const ScanCameraState(
      {@required this.flash,
      @required this.camera,
      @required this.foundQR,
      this.isConnectingWifi});

  ScanCameraState copyWith(
      {String flash, String camera, bool foundQR, bool isConnectingWifi}) {
    return ScanCameraState(
        flash: flash ?? this.flash,
        camera: camera ?? this.camera,
        foundQR: foundQR ?? this.foundQR,
        isConnectingWifi: isConnectingWifi ?? this.isConnectingWifi);
  }

  @override
  List<Object> get props => [flash, camera, foundQR, isConnectingWifi];
}
