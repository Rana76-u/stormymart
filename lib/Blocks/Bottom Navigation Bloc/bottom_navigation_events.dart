abstract class BottomBarEvent {}

class IndexChange extends BottomBarEvent {
  final int currentIndex;

  IndexChange({required this.currentIndex});
}