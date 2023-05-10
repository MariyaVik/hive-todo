import 'package:hive/hive.dart';

import 'nessecary.dart';
part 'todo.g.dart';

@HiveType(typeId: 1)
class Todo extends HiveObject {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final int id;
  @HiveField(2)
  HiveList<Nessecary>? things;
  Todo({
    required this.name,
    required this.id,
  });
  //   List<Thing>? things,
  // }) : things = things ?? [];

  void addNes(Box<Nessecary> box, Nessecary nes) {
    things ??= HiveList(box);
    things?.add(nes);
  }
}
