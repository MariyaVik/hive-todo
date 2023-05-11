import 'package:hive/hive.dart';

part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;
  Todo({
    required this.name,
    required this.id,
  });
}
