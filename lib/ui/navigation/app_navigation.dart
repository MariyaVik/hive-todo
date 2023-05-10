import 'package:flutter/material.dart';

import '../nes_list_screen.dart';
import '../todo_list_screen.dart';

abstract class AppNavName {
  static const String todo = '/';
  static const String nessecary = '/nes';
}

class AppNavigation {
  static const initialRoute = AppNavName.todo;

  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    switch (settings.name) {
      case AppNavName.todo:
        return MaterialPageRoute(builder: (context) => const TodoListPage());
      case AppNavName.nessecary:
        final arg = settings.arguments as int;
        return MaterialPageRoute(
            builder: (context) => NecListPage(todoKey: arg));

      default:
        return MaterialPageRoute(
            builder: (context) => const Scaffold(
                body: Center(child: Text('Navigation error!!!'))));
    }
  }
}
