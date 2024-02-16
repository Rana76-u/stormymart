import 'package:flutter_bloc/flutter_bloc.dart';
import 'cart_events.dart';
import 'cart_states.dart';

class CartBloc extends Bloc<CartEvents, CartState> {
  CartBloc() : super(const CartState(checkList: [], isAllSelected: false)) { //, isAllSelected: false
    on<CartEvents>((event, emit) {

      if(event is AddCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList)..add(event.isChecked);
        emit(CartState(checkList: updatedCheckList, isAllSelected: state.isAllSelected)); //, isAllSelected: state.isAllSelected
      }
      else if(event is UpdateCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList);
        updatedCheckList[event.index] = event.isChecked;
        emit(CartState(checkList: updatedCheckList,isAllSelected: state.isAllSelected)); // ,isAllSelected: state.isAllSelected
      }
      else if(event is SelectAllCheckList){
        final List<bool> updatedCheckList = List.from(state.checkList);
        for(int i=0; i<updatedCheckList.length; i++){
          updatedCheckList[i] = event.isSelectAll;
        }
        emit(CartState(checkList: updatedCheckList, isAllSelected: event.isSelectAll));
      }
      else if(event is UpdateIsSelected){
        emit(CartState(checkList: List.from(state.checkList), isAllSelected: event.isSelectAll)); // ,isAllSelected: state.isAllSelected
      }

    });
  }
}
