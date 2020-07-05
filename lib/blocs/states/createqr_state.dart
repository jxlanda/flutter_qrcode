import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class CreateQRState extends Equatable {
  const CreateQRState();

  @override
  List<Object> get props => [];
}

class StepperFormState extends CreateQRState {
  final int currentStep;
  final bool completed;

  const StepperFormState({@required this.currentStep, this.completed});

  StepperFormState copyWith({int currentStep, bool completed}) {
    return StepperFormState(
        currentStep: currentStep ?? this.currentStep,
        completed: completed ?? this.completed);
  }

  @override
  List<Object> get props => [currentStep, completed];
}
