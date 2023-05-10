import 'package:hive/hive.dart';
part 'nessecary.g.dart';

@HiveType(typeId: 0)
class Nessecary extends HiveObject {
  @HiveField(0)
  bool complete;
  @HiveField(1)
  String id;
  @HiveField(2)
  String note;
  @HiveField(3)
  String task;
  Nessecary(
      {this.complete = false,
      required this.id,
      required this.note,
      this.task = ''});
}
