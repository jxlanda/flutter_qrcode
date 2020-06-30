import 'package:qrcode/blocs/blocs.dart';
// Plugins
import 'package:flutter_bloc/flutter_bloc.dart';

class BottomNavigationBloc extends Bloc<BottomNavigationEvent, BottomNavigationState> {

  int currentIndex = 0;

  @override
  BottomNavigationState get initialState => CurrentIndexChanged(currentIndex: this.currentIndex);

  @override
  Stream<BottomNavigationState> mapEventToState(BottomNavigationEvent event) async* {
    if(event is PageTapped){
      this.currentIndex = event.index;
      yield CurrentIndexChanged(currentIndex: this.currentIndex);
    }
  }
}