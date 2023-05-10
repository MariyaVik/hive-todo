import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/boxes.dart';
import '../models/nessecary.dart';
import '../models/todo.dart';

class NecListPage extends StatefulWidget {
  const NecListPage({super.key, required this.todoKey});
  final int todoKey;
  @override
  State<NecListPage> createState() => _NecListPageState();
}

class _NecListPageState extends State<NecListPage> {
  TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final todoBox = Hive.box<Todo>(BoxName.todo);
    Todo todo = todoBox.get(widget.todoKey)!;
    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
      ),
      body: Column(
        children: [
          Expanded(
            child: ValueListenableBuilder(
                valueListenable: Hive.box<Todo>(BoxName.todo)
                    .listenable(keys: [widget.todoKey]),
                builder: (context, box, _) {
                  Todo t = box.get(widget.todoKey)!;
                  if (t.things == null || t.things!.isEmpty) {
                    return const Center(
                      child: Text('Список пуст'),
                    );
                  }
                  return ListView.builder(
                      itemCount: t.things?.length,
                      itemBuilder: (context, index) {
                        Nessecary nes = t.things![index];
                        return Dismissible(
                          key: Key(nes.id),
                          behavior: HitTestBehavior.opaque,
                          onDismissed: (direction) {
                            nes.delete();
                          },
                          background: Container(
                            color: Colors.red,
                            child: const Icon(Icons.delete),
                          ),
                          child: CheckboxListTile(
                            title: Text(nes.note),
                            onChanged: (bool? value) {
                              nes.complete = !nes.complete;
                              nes.save();
                              t.save();
                            },
                            value: nes.complete,
                          ),
                        );
                      });
                }),
          ),
          Row(
            children: [
              Expanded(
                  child: TextField(
                controller: controller,
                decoration: const InputDecoration(border: OutlineInputBorder()),
              )),
              ElevatedButton(
                  onPressed: () {
                    final Box<Nessecary> nesBox =
                        Hive.box<Nessecary>(BoxName.nessecary);
                    final nes = Nessecary(
                        note: controller.text, id: nesBox.length.toString());
                    nesBox.add(nes);

                    final Box<Todo> toodBox = Hive.box<Todo>(BoxName.todo);
                    final todo = toodBox.get(widget.todoKey);
                    todo?.addNes(nesBox, nes);
                    todo?.save();
                    controller.clear();
                  },
                  child: const Text('Добавить'))
            ],
          )
        ],
      ),
    );
  }
}
