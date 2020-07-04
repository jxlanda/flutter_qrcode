import 'package:qrcode/blocs/blocs.dart';
import 'package:qrcode/environment/environment.dart' as env;
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qrcode/repositories/hivedb_repository.dart';
import 'package:qrcode/models/qr_model.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';

class PanelCameraBloc extends Bloc<PanelCameraEvent, PanelCameraState> {
  String qrText = '';
  PanelController panelController;
  Scan currentScan;
  double panelMinHeight = 0.0;
  double panelExpandedMinHeight = 62.0;
  bool isConnectingWifi = false;

  PanelCameraBloc()
      : super(ShowPanelState(foundQR: false, isConnectingWifi: false));

  @override
  Stream<PanelCameraState> mapEventToState(PanelCameraEvent event) async* {
    // Si se especifica el state permite hacer copyWith
    final scanState = state as ShowPanelState;
    if (event is NotFoundQRCode) yield scanState.copyWith(foundQR: false);
    if (event is FoundQRCode) {
      panelController = event.panelController;
      // Asigmanos el valor del evento
      qrText = event.qr;
      // Mostramos el slidingPanel
      panelMinHeight = panelExpandedMinHeight;
      // Expandimos al maximo el slidingPanel
      panelController.open();
      // Agregamos el QR a la base de datos
      final Scan scan = new Scan(value: event.qr, dateTime: DateTime.now());
      // Asigmamos el scan creado al currentScan
      currentScan = scan;
      final HiveDatabase database = new HiveDatabase();
      await database.addToDatabase(
          database: env.HiveHistory,
          record: scan,
          type: env.HiveTypes.Scan.toString());
      // Cambiamos las propiedasdes del state
      yield scanState.copyWith(foundQR: true);
    }
    if (event is ConnectingWifi) {
      // Asignamos el estado de conexion a la variable local
      isConnectingWifi = event.isConnecting;
      // Reconstruimos la interfaz
      yield scanState.copyWith(isConnectingWifi: isConnectingWifi);
    }
  }
}
