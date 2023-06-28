import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:todo_app_project/db_handler.dart';
import 'package:todo_app_project/home_screen.dart';
import 'package:todo_app_project/model.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:todo_app_project/notifications.dart';

class AddUpdateTask extends StatefulWidget {
  int? todoId;
  String? todoTitle;
  String? todoDT;
  bool? update;

  AddUpdateTask({
    this.todoId,
    this.todoTitle,
    this.todoDT,
    this.update,
  });

  @override
  State<AddUpdateTask> createState() => _AddUpdateTaskState();
}

class _AddUpdateTaskState extends State<AddUpdateTask> {
  DBHelper? dbHelper;
  late Future<List<TodoModel>> dataList;

  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _dateAndTimeController = TextEditingController();
  final _reminderTimeController = TextEditingController(); // Added line
  DateTime? _selectedDate;
  TimeOfDay? _selectedTime;
  TimeOfDay? _selectedReminderTime; // Added line

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
      FlutterLocalNotificationsPlugin();

  @override
  void initState() {
    super.initState();
    dbHelper = DBHelper();
    loadData();
    _titleController.text = widget.todoTitle ?? '';
    _dateAndTimeController.text = widget.todoDT ?? '';
    initializeNotifications();
  }

  void initializeNotifications() async {
    var initializationSettingsAndroid =
        AndroidInitializationSettings('@mipmap/ic_launcher');
    var initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
    );
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
  }

  loadData() async {
    dataList = dbHelper!.getDataList();
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );
    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dateAndTimeController.text = _formatDateTime();
      });
    }
  }

  Future<void> _selectTime(BuildContext context) async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedTime) {
      setState(() {
        _selectedTime = picked;
        _dateAndTimeController.text = _formatDateTime();
      });
    }
  }

  Future<void> _selectReminderTime(BuildContext context) async { // Added method
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: _selectedReminderTime ?? TimeOfDay.now(),
    );
    if (picked != null && picked != _selectedReminderTime) {
      setState(() {
        _selectedReminderTime = picked;
        _reminderTimeController.text = _formatReminderTime();
      });
    }
  }

  String _formatDateTime() {
    if (_selectedDate != null && _selectedTime != null) {
      final DateTime now = DateTime.now();
      final DateTime dateTime = DateTime(
        _selectedDate!.year,
        _selectedDate!.month,
        _selectedDate!.day,
        _selectedTime!.hour,
        _selectedTime!.minute,
      );

      if (_selectedDate!.year == now.year &&
          _selectedDate!.month == now.month &&
          _selectedDate!.day == now.day) {
        // Display "today" for the current date
        final String formattedDateTime = 'Today ${_formatTime(dateTime)}';
        return formattedDateTime;
      } else {
        // Display the formatted date and time for other dates
        final String formattedDateTime =
            '${DateFormat.yMd().format(dateTime)} ${_formatTime(dateTime)}';
        return formattedDateTime;
      }
    }

    return '';
  }

  String _formatReminderTime() { // Added method
    if (_selectedReminderTime != null) {
      final DateTime now = DateTime.now();
      final DateTime reminderDateTime = DateTime(
        now.year,
        now.month,
        now.day,
        _selectedReminderTime!.hour,
        _selectedReminderTime!.minute,
      );

      final String formattedReminderTime =
          '${_formatTime(reminderDateTime)}';
      return formattedReminderTime;
    }

    return '';
  }

  String _formatTime(DateTime dateTime) {
    final String hour = _formatHour(dateTime.hour);
    final String minute = _formatMinute(dateTime.minute);
    final String period = (dateTime.hour < 12) ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String _formatHour(int hour) {
    if (hour == 0) {
      return '12';
    } else if (hour > 12) {
      return '${hour - 12}';
    }
    return '$hour';
  }

  String _formatMinute(int minute) {
    return (minute < 10) ? '0$minute' : '$minute';
  }

  void _saveTodo() {
    if (_formKey.currentState!.validate()) {
      final String title = _titleController.text;
      final String dateAndTime = _dateAndTimeController.text;

      if (widget.update == true) {
        dbHelper!.update(TodoModel(
          id: widget.todoId,
          title: title,
          dateandtime: dateAndTime,
        ));
      } else {
        dbHelper!.insert(TodoModel(
          title: title,
          dateandtime: dateAndTime,
        ));
      }

      if (_selectedDate != null && _selectedTime != null && _selectedReminderTime != null) {
        DateTime dueDateTime = DateTime(
          _selectedDate!.year,
          _selectedDate!.month,
          _selectedDate!.day,
          _selectedTime!.hour,
          _selectedTime!.minute,
        );

        DateTime reminderDateTime = DateTime(
          dueDateTime.year,
          dueDateTime.month,
          dueDateTime.day,
          _selectedReminderTime!.hour,
          _selectedReminderTime!.minute,
        );

        Noti.showNotification(
          id: 0,
          title: 'Task Reminder',
          body: 'Your task "$title" is due soon!',
          scheduledTime: reminderDateTime,
          fln: flutterLocalNotificationsPlugin,
        );
      }

      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => HomeScreen()),
      );

      _titleController.clear();
      _dateAndTimeController.clear();
      _reminderTimeController.clear();

      // To check if it's working or not
      print('Data added');
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _dateAndTimeController.dispose();
    _reminderTimeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.update == true ? 'Update Task' : 'Add Task',
          style: TextStyle(
            fontSize: 22,
            fontWeight: FontWeight.bold,
            letterSpacing: 1,
          ),
        ),
        centerTitle: true,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20, vertical: 100),
          child: Column(
            children: [
              Form(
                key: _formKey,
                child: Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 20),
                      child: TextFormField(
                        keyboardType: TextInputType.multiline,
                        controller: _titleController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(),
                          hintText: 'Enter Task',
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return 'Enter some text';
                          }
                          return null;
                        },
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selectDate(context);
                        _selectTime(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _dateAndTimeController,
                          decoration: InputDecoration(
                            labelText: 'Due Date and Time',
                            suffixIcon: Icon(
                              Icons.calendar_today,
                              color: Color.fromRGBO(124, 255, 100, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    GestureDetector(
                      onTap: () {
                        _selectReminderTime(context);
                      },
                      child: AbsorbPointer(
                        child: TextFormField(
                          controller: _reminderTimeController,
                          decoration: InputDecoration(
                            labelText: 'Reminder me at',
                            suffixIcon: Icon(
                              Icons.alarm,
                              color: Color.fromRGBO(124, 255, 100, 1),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: 16.0),
                    ElevatedButton(
                      onPressed: _saveTodo,
                      child: Text('Save'),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}