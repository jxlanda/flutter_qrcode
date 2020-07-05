import 'package:qrcode/blocs/blocs.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:sliding_up_panel/sliding_up_panel.dart';
import 'package:qrcode/environment/environment.dart' as env;

class CreateQRBloc extends Bloc<CreateQREvent, CreateQRState> {
  final PanelController panelController = new PanelController();
  final List<env.ScanTypes> scanTypes = env.ScanTypes.values;
  final finalStep = 2;

  CreateQRBloc() : super(StepperFormState(currentStep: 0, completed: false));

  @override
  Stream<CreateQRState> mapEventToState(CreateQREvent event) async* {
    final StepperFormState stepper = state as StepperFormState;
    if (event is ChangeStep) {
      // Determina si el panel esta expandido o no
      if (!panelController.isPanelOpen) await panelController.open();
      // Si el currentStep es menor o igual a finalStep
      if (event.step <= finalStep) {
        yield stepper.copyWith(currentStep: event.step, completed: true);
      }
    }
  }
}
