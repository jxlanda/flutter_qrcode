import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

abstract class BottomNavigationEvent extends Equatable {
  const BottomNavigationEvent();
}

class AppStarted extends BottomNavigationEvent {
  @override
  String toString() => 'AppStarted';

  @override
  List<Object> get props => [];
}

class PageTapped extends BottomNavigationEvent {

  final int index;

  const PageTapped({@required this.index});

  @override
  String toString() => 'PageTapped: $index';

  @override
  List<Object> get props => [index];
}