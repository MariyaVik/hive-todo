import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:hive_todo/domain/models/boxes.dart';
import 'package:hive_todo/domain/models/nessecary.dart';

import 'models/todo.dart';

class BoxManager {
  Box<Todo> get todoBox => Hive.box<Todo>(BoxName.todo);
  Box<Nessecary> nesBox(int todoKey) =>
      Hive.box<Nessecary>(BoxName.nessecary + todoKey.toString());

  Future<Box<Todo>> openTodoBox() async {
    return await openBox(BoxName.todo, 1, TodoAdapter());
  }

  Future<Box<Nessecary>> openNesBox(int todoKey) async {
    return await openBox(
        BoxName.nessecary + todoKey.toString(), 0, NessecaryAdapter());
  }

  Future<Box<T>> openBox<T>(
      String boxName, int typeId, TypeAdapter<T> adapter) async {
    if (!Hive.isAdapterRegistered(typeId)) {
      Hive.registerAdapter(adapter);
    }
    return await Hive.openBox<T>(boxName);
  }

  void closeBox<T>(Box<T> box) async {
    await box.compact();
    await box.close();
  }

  void toggleNes(Nessecary nes) {
    nes.complete = !nes.complete;
    nes.save();
  }

  void addNes(TextEditingController controller, int todoKey) {
    final Box<Nessecary> nesBox = this.nesBox(todoKey);
    final int id =
        nesBox.isEmpty ? 1 : 1 + (nesBox.getAt(nesBox.length - 1)?.id ?? 1);
    final nes = Nessecary(note: controller.text, id: id);
    nesBox.add(nes);
    controller.clear();
  }
}
