import 'dart:io';

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
  final File image;

  const StepperFormState(
      {@required this.currentStep, this.completed, this.color, this.image});

  StepperFormState copyWith(
      {int currentStep, bool completed, String color, File image}) {
    return StepperFormState(
        currentStep: currentStep ?? this.currentStep,
        completed: completed ?? this.completed,
        color: color ?? this.color,
        image: image ?? this.image);
  }

  @override
  List<Object> get props => [currentStep, color, completed, image];
}
