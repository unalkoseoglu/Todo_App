import 'package:flutter/material.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:intl/intl.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:todo_app/database/local_storage.dart';

import 'package:todo_app/main.dart';
import 'package:todo_app/models/task_model.dart';
import 'package:todo_app/widgets/components/show_alertdialog.dart';
import '../widgets/task_list_item.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  // Color();
  final Color _mainColor = const Color(0xFF0d0952);
  final Color _showModalColor = const Color(0xDC6F73EC);
  final Color _whiteColor = const Color(0xECFFFFFF);
  // Text(string);
  final String _appBarTittle = 'My To-Do!';
  final String _nowAddTask = 'Now Add Task!';
  final String _taskDelete = 'Task Delete!';
  final String _todayTxt = 'Today';
  final String _montlyTxt = 'Monthly';
  String _filterType = 'today';

  // TaskList
  late List<Task> _alltask;
  // Database
  late LocalStorage _localStorage;

  @override
  void initState() {
    super.initState();
    _localStorage = locator<LocalStorage>();
    _alltask = <Task>[];
    _getalltaskFromDb();
  }

  Future<void> _getalltaskFromDb() async {
    _alltask = await _localStorage.getAllTask();
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        body: Stack(children: [
      Column(
        children: [
          _appBar(),
          Container(
            height: MediaQuery.of(context).size.height * 0.1,
            width: MediaQuery.of(context).size.width,
            color: _mainColor,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _todaySelected(context),
                _monthlySelected(context),
              ],
            ),
          ),
          (_filterType == 'today') ? _todayCalendar() : Container(),
          (_filterType == 'monthly') ? _monthlyCalendar() : Container(),
          Expanded(
              child: (_alltask.isNotEmpty)
                  ? _taskListBuilder()
                  : Center(
                      child: Text(_nowAddTask),
                    )),
          _bottomBar(context),
        ],
      ),
    ]));
  }

  AppBar _appBar() {
    return AppBar(
      elevation: 0,
      centerTitle: true,
      backgroundColor: _mainColor,
      title: Text(
        _appBarTittle,
        style:
            Theme.of(context).textTheme.headline4!.copyWith(color: _whiteColor),
      ),
      actions: [
        IconButton(onPressed: () {}, icon: const Icon(Icons.short_text))
      ],
    );
  }

  Column _todaySelected(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            changeFilter('today');
          },
          child: Text(
            _todayTxt,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: _whiteColor),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.008,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.003,
            width: MediaQuery.of(context).size.width * 0.3,
            color: (_filterType == 'today') ? _whiteColor : Colors.transparent)
      ],
    );
  }

  TableCalendar<dynamic> _todayCalendar() {
    return TableCalendar(
        onFormatChanged: (format) {},
        onDaySelected: (selectedDay, focusedDay) {},
        calendarFormat: CalendarFormat.week,
        calendarBuilders: const CalendarBuilders(),
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2022, 02, 25),
        lastDay: DateTime.utc(2030, 01, 01));
  }

  Column _monthlySelected(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        InkWell(
          onTap: () {
            changeFilter('monthly');
          },
          child: Text(
            _montlyTxt,
            style: Theme.of(context)
                .textTheme
                .headline6!
                .copyWith(color: _whiteColor),
          ),
        ),
        SizedBox(
          height: MediaQuery.of(context).size.height * 0.008,
        ),
        Container(
            height: MediaQuery.of(context).size.height * 0.003,
            width: MediaQuery.of(context).size.width * 0.3,
            color:
                (_filterType == 'monthly') ? _whiteColor : Colors.transparent)
      ],
    );
  }

  TableCalendar<dynamic> _monthlyCalendar() {
    return TableCalendar(
        onFormatChanged: (format) {},
        onDaySelected: (selectedDay, focusedDay) {},
        calendarFormat: CalendarFormat.month,
        calendarBuilders: const CalendarBuilders(),
        headerVisible: true,
        daysOfWeekVisible: true,
        sixWeekMonthsEnforced: true,
        shouldFillViewport: false,
        focusedDay: DateTime.now(),
        firstDay: DateTime.utc(2022, 02, 25),
        lastDay: DateTime.utc(2030, 01, 01));
  }

  ListView _taskListBuilder() {
    return ListView.builder(
      itemCount: _alltask.length,
      itemBuilder: (context, index) {
        var nowTask = _alltask[index];
        return Padding(
          padding: EdgeInsets.symmetric(
              vertical: MediaQuery.of(context).size.height * 0.005,
              horizontal: MediaQuery.of(context).size.width * 0.03),
          child: Column(
            children: [
              Dismissible(
                key: Key(nowTask.id.toString()),
                background: Row(
                  children: [const Icon(Icons.delete), Text(_taskDelete)],
                ),
                direction: DismissDirection.startToEnd,
                onDismissed: (direction) {
                  _alltask.removeAt(index);
                  _localStorage.deleteTask(task: nowTask);

                  setState(() {});
                },
                child: TaskListItem(task: nowTask),
              ),
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBar _bottomBar(BuildContext context) {
    return BottomNavigationBar(
      items: [
        BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.menu),
              onPressed: () {},
            ),
            label: ''),
        BottomNavigationBarItem(
            icon: CircleAvatar(
              backgroundColor: _showModalColor,
              child: IconButton(
                onPressed: () {
                  _showAddTaskBottomSheet(context);
                },
                icon: Icon(Icons.add),
                color: _whiteColor,
              ),
            ),
            label: ' '),
        BottomNavigationBarItem(
            icon: IconButton(
              icon: Icon(Icons.supervisor_account),
              onPressed: () {},
            ),
            label: ''),
      ],
      currentIndex: 1,
    );
  }

  void _showAddTaskBottomSheet(BuildContext context) {
    const String _hintTxt = 'New Add Task';
    final _fieldText = TextEditingController();

    showModalBottomSheet(
        context: context,
        builder: (context) {
          return Container(
              padding: EdgeInsets.only(
                  bottom: MediaQuery.of(context).viewInsets.bottom),
              width: MediaQuery.of(context).size.width,
              color: _showModalColor,
              child: ListTile(
                  title: TextField(
                autofocus: true,
                controller: _fieldText,
                decoration: const InputDecoration(
                  hintText: _hintTxt,
                  border: InputBorder.none,
                ),
                onSubmitted: (value) {
                  Navigator.of(context).pop();

                  if (value.length > 3) {
                    DatePicker.showDateTimePicker(context, onConfirm: (time) {
                      DatePicker.showTimePicker(context,
                          showSecondsColumn: false);
                      var nowAddTask = Task.create(name: value, dateTime: time);
                      _alltask.insert(0, nowAddTask);
                      _localStorage.addTask(task: nowAddTask);
                      _fieldText.clear();

                      setState(() {});
                    });
                  } else {
                    showAlertDialog(context);
                  }
                },
              )));
        });
  }

  void changeFilter(String filter) {
    _filterType = filter;
    setState(() {});
  }
}
