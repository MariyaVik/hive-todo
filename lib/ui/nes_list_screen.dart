import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/domain/box_manager.dart';

import '../domain/models/boxes.dart';
import '../domain/models/nessecary.dart';
import '../domain/models/todo.dart';

class NecListPage extends StatefulWidget {
  const NecListPage({super.key, required this.todoKey});
  final int todoKey;
  @override
  State<NecListPage> createState() => _NecListPageState();
}

class _NecListPageState extends State<NecListPage> {
  TextEditingController controller = TextEditingController();
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    await BoxManager().openNesBox(widget.todoKey);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    final todoBox = BoxManager().todoBox;
    Todo todo = todoBox.get(widget.todoKey)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(todo.name),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            BoxManager().closeBox(BoxManager().nesBox(widget.todoKey));
            Navigator.of(context).pop();
          },
        ),
      ),
      body: !Hive.isBoxOpen(BoxName.nessecary + widget.todoKey.toString())
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Expanded(
                  child: ValueListenableBuilder(
                      valueListenable:
                          BoxManager().nesBox(widget.todoKey).listenable(),
                      builder: (context, box, _) {
                        if (box.isEmpty) {
                          return const Center(
                            child: Text('Список пуст'),
                          );
                        }
                        return ListView.builder(
                            itemCount: box.length,
                            itemBuilder: (context, index) {
                              Nessecary nes = box.getAt(index)!;
                              return Dismissible(
                                key: Key(nes.id.toString()),
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
                                    BoxManager().toggleNes(nes);
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
                      decoration:
                          const InputDecoration(border: OutlineInputBorder()),
                    )),
                    ElevatedButton(
                        onPressed: () {
                          BoxManager().addNes(controller, widget.todoKey);
                        },
                        child: const Text('Добавить'))
                  ],
                )
              ],
            ),
    );
  }
}
