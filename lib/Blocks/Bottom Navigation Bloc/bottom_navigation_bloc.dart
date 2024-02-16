
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stormymart/Blocks/Bottom%20Navigation%20Bloc/bottom_navigation_events.dart';
import 'package:stormymart/Blocks/Bottom%20Navigation%20Bloc/bottom_navigation_states.dart';

class BottomBarBloc extends Bloc<BottomBarEvent, BottomBarState> {
  BottomBarBloc() : super(const BottomBarState(currentIndex: 0)) {
    on<BottomBarEvent>((event, emit) {
      if(event is IndexChange){
        emit(BottomBarInitial(currentIndex: event.currentIndex));
      }
    });
  }
}