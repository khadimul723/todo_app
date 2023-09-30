import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/pages/new_todo.dart';
import 'package:todo_app/providers/todo_provider.dart';

class TodoHome extends StatelessWidget {
  static const String routeName = '/';

  const TodoHome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.blue,
          centerTitle: true,
          title: const Text('TODO LIST'),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () => Navigator.pushNamed(context, NewTodo.routeName),
          child: const Icon(Icons.add),
        ),
        body: Consumer<TodoProvider>(
          builder: (context, provider, child) => ListView.builder(
            itemCount: provider.todoList.length,
            itemBuilder: (context, index) {
              final todo = provider.todoList[index];
              return ListTile(
                leading: Icon(Icons.star, size: 30, color: getPriorityColor(todo.priority),),
                title: Text(todo.name),
                trailing: Checkbox(
                  value: todo.isCompleted,
                  onChanged: (value) {
                    provider.changeTodoStatus(todo);
                  },
                ),
              );
            },
          ),
        ),
    );
  }
  Color getPriorityColor (String priority) {
    if (priority == 'Low') {
      return Colors.yellow;
    }
    else if ( priority == 'Normal') {
      return Colors.green;
    }
    else{
      return Colors.red;
    }
  }
}
