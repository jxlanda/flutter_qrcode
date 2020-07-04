import 'package:meta/meta.dart';
import 'package:equatable/equatable.dart';

@immutable
abstract class BottomNavigationState extends Equatable {
  const BottomNavigationState();

  @override
  List<Object> get props => [];
}

class CurrentIndexChanged extends BottomNavigationState {
  final int currentIndex;

  CurrentIndexChanged({@required this.currentIndex});

  @override
  String toString() => 'CurrentIndexChanged to $currentIndex';

  @override
  List<Object> get props => [currentIndex];
}

class HomePageLoaded extends BottomNavigationState {
  const HomePageLoaded();

  @override
  String toString() => 'HomePage Loaded';
  @override
  List<Object> get props => [];
}

class HistoryPageLoaded extends BottomNavigationState {
  const HistoryPageLoaded();

  @override
  String toString() => 'HistoryPage Loaded';
  @override
  List<Object> get props => [];
}

class CreateQRPageLoaded extends BottomNavigationState {
  const CreateQRPageLoaded();

  @override
  String toString() => 'Create QR Page Loaded';
  @override
  List<Object> get props => [];
}

class SettingsPageLoaded extends BottomNavigationState {
  const SettingsPageLoaded();

  @override
  String toString() => 'Settings Page Loaded';
  @override
  List<Object> get props => [];
}
