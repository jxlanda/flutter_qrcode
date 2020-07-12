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
  final String color;
  final bool completed;

  const StepperFormState(
      {@required this.currentStep, this.completed, this.color});

  StepperFormState copyWith({int currentStep, bool completed, String color}) {
    return StepperFormState(
      currentStep: currentStep ?? this.currentStep,
      completed: completed ?? this.completed,
      color: color ?? this.color,
    );
  }

  @override
  List<Object> get props => [currentStep, color];
}
