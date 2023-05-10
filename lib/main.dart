import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:hive_todo/ui/navigation/app_navigation.dart';

import 'models/boxes.dart';
import 'models/nessecary.dart';
import 'models/todo.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Hive.initFlutter();
  Hive.registerAdapter(TodoAdapter());
  Hive.registerAdapter(NessecaryAdapter());
  await Hive.openBox<Todo>(BoxName.todo);
  await Hive.openBox<Nessecary>(BoxName.nessecary);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      initialRoute: AppNavigation.initialRoute,
      onGenerateRoute: AppNavigation.onGenerateRoute,
    );
  }
}
