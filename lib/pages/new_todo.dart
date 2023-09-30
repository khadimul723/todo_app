import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:todo_app/custom_button.dart';
import 'package:todo_app/models/todo_model.dart';
import 'package:todo_app/providers/todo_provider.dart';
import 'package:todo_app/utils/helpers_functions.dart';

class NewTodo extends StatefulWidget {
  static const String routeName = '/new';

  const NewTodo({super.key});

  @override
  State<NewTodo> createState() => _NewTodoState();
}

class _NewTodoState extends State<NewTodo> {
  final _todoController = TextEditingController();
  final _priorityList = const ['Low', 'Normal', 'High'];
  String? priority;
  DateTime? selectedDate;
  TimeOfDay? selectedTime;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        centerTitle: true,
        title: const Text('ADD TODO'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(16.0),
        children: [
          Padding(
            padding: const EdgeInsets.all(10.0),
            child: TextField(
              keyboardType: TextInputType.text,
              controller: _todoController,
              decoration: const InputDecoration(hintText: 'what to do?'),
            ),
          ),
          const SizedBox(
            height: 50.0,
          ),
          Card(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: DropdownButton(
                value: priority,
                hint: const Text('Select Priority'),
                isExpanded: true,
                items: _priorityList
                    .map((e) => DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    priority = value;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: CustomButton(
              title: selectedDate == null ? 'Select Date' : getFormattedDate(),
              onPressed: _selectDate,
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Center(
            child: CustomButton(
              title: selectedTime == null ? 'Select Time' : getFormattedTime(),
              onPressed: _selectTime,
            ),
          ),
          const SizedBox(
            height: 40,
          ),
          Center(
            child: CustomButton(
              title: 'SAVE',
              onPressed: _saveTodo,
            ),
          )
        ],
      ),
    );
  }

  @override
  void dispose() {
    _todoController.dispose();
    super.dispose();
  }

  void _selectDate() async {
    final date = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 60)),
    );

    if (date != null) {
      setState(() {
        selectedDate = date;
      });
    }
  }

  String getFormattedDate() => DateFormat('dd. MM. yyyy').format(selectedDate!);

  String getFormattedTime() => DateFormat('hh: mm')
      .format(DateTime(0, 0, 0, selectedTime!.hour, selectedTime!.minute));

  void _selectTime() async {
    final time = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
    );
    if (time != null) {
      setState(() {
        selectedTime = time;
      });
    }
  }

  void _saveTodo() {
    if (_todoController.text.isEmpty) {
      showMsg(context, 'Todo name not found');
      return;
    }
    if (priority == null) {
      showMsg(context, 'Priority not found');
      return;
    }
    if (selectedDate == null) {
      showMsg(context, 'Date not selected');
      return;
    }
    if (selectedTime == null) {
      showMsg(context, 'Time not found');
      return;
    }

    final todo = TodoModel(
      id: DateTime.now().millisecondsSinceEpoch,
      name: _todoController.text,
      priority: priority!,
      date: selectedDate!,
      time: selectedTime!,
    );
    Provider.of<TodoProvider>(context, listen: false).addTodo(todo);
    Navigator.pop(context);
  }
}
