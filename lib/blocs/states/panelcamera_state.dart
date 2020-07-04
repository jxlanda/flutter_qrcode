import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class PanelCameraState extends Equatable {
  const PanelCameraState();

  @override
  List<Object> get props => [];
}

class ShowPanelState extends PanelCameraState {
  final bool foundQR;
  final bool isConnectingWifi;

  const ShowPanelState({@required this.foundQR, this.isConnectingWifi});

  ShowPanelState copyWith({bool foundQR, bool isConnectingWifi}) {
    return ShowPanelState(
        foundQR: foundQR ?? this.foundQR,
        isConnectingWifi: isConnectingWifi ?? this.isConnectingWifi);
  }

  @override
  List<Object> get props => [foundQR, isConnectingWifi];
}
