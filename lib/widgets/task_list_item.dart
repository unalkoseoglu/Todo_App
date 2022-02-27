import 'package:flutter/material.dart';

import 'package:intl/intl.dart';
import 'package:todo_app/database/local_storage.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';

class TaskListItem extends StatefulWidget {
  final Task task;
  const TaskListItem({
    Key? key,
    required this.task,
  }) : super(key: key);

  @override
  State<TaskListItem> createState() => _TaskListItemState();
}

class _TaskListItemState extends State<TaskListItem> {
  late LocalStorage _localStorage;

  final DateFormat _dateFormat = DateFormat('hh:mm a');

  final Color _cardColor = const Color(0xE0A9ABDF);
  final Color _boxShadowColor = const Color(0x91454BFD);
  final _fieldText = TextEditingController();

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _fieldText.text = widget.task.title;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
          color: _cardColor,
          borderRadius: BorderRadius.circular(8),
          boxShadow: [
            BoxShadow(
              color: _boxShadowColor,
              blurRadius: 5,
            )
          ]),
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      width: MediaQuery.of(context).size.width,
      child: ListTile(
          trailing: Text(
            _dateFormat.format(
              widget.task.datetime,
            ),
          ),
          title: widget.task.taskCompleted
              ? Text(widget.task.title)
              : TextField(
                  minLines: 1,
                  maxLines: null,
                  textInputAction: TextInputAction.done,
                  controller: _fieldText,
                  decoration: const InputDecoration(border: InputBorder.none),
                  onSubmitted: (nowTask) {
                    if (nowTask.length > 3) {
                      widget.task.title = nowTask;
                      _localStorage.updateTask(task: widget.task);
                    }
                  },
                )),
    );
  }
}
