import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class CreateQREvent extends Equatable {
  const CreateQREvent();
}

class ChangeStep extends CreateQREvent {
  final int step;

  const ChangeStep({@required this.step});

  @override
  List<Object> get props => [step];

  @override
  String toString() => 'Go to Step: $step';
}
