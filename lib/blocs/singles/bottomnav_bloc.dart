import 'package:qrcode/blocs/blocs.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBloc
    extends Bloc<BottomNavigationEvent, BottomNavigationState> {
  int currentIndex = 0;

  // Updated flutter_bloc 5.0
  BottomNavigationBloc() : super(CurrentIndexChanged(currentIndex: 0));

  @override
  Stream<BottomNavigationState> mapEventToState(
      BottomNavigationEvent event) async* {
    if (event is PageTapped) {
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
      // TO DO
      // Agregar paginas al menu
      // if (this.currentIndex == 0) yield HomePageLoaded();
      // if (this.currentIndex == 1) yield HistoryPageLoaded();
      // if (this.currentIndex == 2) yield CreateQRPageLoaded();
      // if (this.currentIndex == 3) yield SettingsPageLoaded();
    }
  }
}
