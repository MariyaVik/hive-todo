import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/domain/box_manager.dart';
import 'package:hive_todo/ui/navigation/app_navigation.dart';

import '../domain/models/boxes.dart';
import '../domain/models/todo.dart';

class TodoListPage extends StatelessWidget {
  const TodoListPage({super.key});

  void addPurchaseDialog(BuildContext context) async {
    await showDialog(
        context: context,
        builder: (context) {
          return const AddPuchaseWidget();
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Список')),
      body: const TodoListWidget(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          addPurchaseDialog(context);
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}

class TodoListWidget extends StatefulWidget {
  const TodoListWidget({super.key});

  @override
  State<TodoListWidget> createState() => _TodoListWidgetState();
}

class _TodoListWidgetState extends State<TodoListWidget> {
  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
        valueListenable: BoxManager().todoBox.listenable(),
        builder: (context, box, _) {
          if (box.isEmpty) {
            return const Center(
              child: Text('Список пуст'),
            );
          }
          return ListView.builder(
              itemCount: box.length,
              itemBuilder: (context, intex) => TodoRowWidget(index: intex));
        });
  }
}

class TodoRowWidget extends StatelessWidget {
  const TodoRowWidget({super.key, required this.index});
  final int index;

  @override
  Widget build(BuildContext context) {
    Todo todo = BoxManager().todoBox.getAt(index)!;
    return Dismissible(
      key: Key(todo.id.toString()),
      background: Container(color: Colors.red),
      child: ListTile(
        title: Text(todo.name),
        trailing: const Icon(Icons.chevron_right),
        onTap: () {
          int key = BoxManager().todoBox.keyAt(index);
          Navigator.of(context).pushNamed(AppNavName.nessecary, arguments: key);
        },
      ),
      onDismissed: (direction) async {
        todo.delete();
      },
    );
  }
}

class AddPuchaseWidget extends StatefulWidget {
  const AddPuchaseWidget({super.key});

  @override
  State<AddPuchaseWidget> createState() => _AddPuchaseWidgetState();
}

class _AddPuchaseWidgetState extends State<AddPuchaseWidget> {
  final TextEditingController nameController = TextEditingController();

  @override
  void dispose() {
    nameController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      content: Container(
        height: 300,
        decoration: const BoxDecoration(),
        child:
            Column(mainAxisAlignment: MainAxisAlignment.spaceAround, children: [
          TextField(
            controller: nameController,
            decoration: const InputDecoration(
                border: OutlineInputBorder(), hintText: 'Название'),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              ElevatedButton(
                  onPressed: addPurchase, child: const Text('Добавить')),
              ElevatedButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  child: const Text('Отмена')),
            ],
          )
        ]),
      ),
    );
  }

  void addPurchase() async {
    if (nameController.text == '') return;

    Box<Todo> box = Hive.box<Todo>(BoxName.todo);
    final int id = box.isEmpty ? 1 : 1 + (box.getAt(box.length - 1)?.id ?? 1);
    box.add(Todo(name: nameController.text, id: id));
    if (context.mounted) {
      Navigator.of(context).pop();
    }
  }
}
