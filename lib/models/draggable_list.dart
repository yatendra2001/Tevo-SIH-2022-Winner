import 'task_model.dart';

class DraggableList {
  final String header;
  final List<DraggableListItem> items;

  const DraggableList({
    required this.header,
    required this.items,
  });
}

class DraggableListItem {
  final Task task;
  const DraggableListItem({required this.task});
}
