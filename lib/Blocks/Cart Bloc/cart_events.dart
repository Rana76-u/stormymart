abstract class CartEvents {}

class AddCheckList extends CartEvents {
  final bool isChecked;

  AddCheckList({required this.isChecked});
}

class UpdateCheckList extends CartEvents {
  final bool isChecked;
  final int index;

  UpdateCheckList({required this.isChecked, required this.index});
}

class RemoveCheckList extends CartEvents {
  final bool isChecked;
  final int index;

  RemoveCheckList({required this.isChecked, required this.index});
}

class SelectAllCheckList extends CartEvents {
  final bool isSelectAll;

  SelectAllCheckList({required this.isSelectAll});
}

class UpdateIsSelected extends CartEvents {
  final bool isSelectAll;

  UpdateIsSelected({required this.isSelectAll});
}
