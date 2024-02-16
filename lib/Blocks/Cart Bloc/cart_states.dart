import 'package:equatable/equatable.dart';

class CartState extends Equatable{
  final List<bool> checkList;
  final bool isAllSelected;

  const CartState({
    required this.checkList,
    required this.isAllSelected
  });

  @override
  List<Object?> get props => [
    checkList,
    isAllSelected
  ];
}
