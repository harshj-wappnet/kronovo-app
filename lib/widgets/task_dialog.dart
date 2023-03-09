import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/sql_helper.dart';
import '../responsive.dart';

class TaskDialoBox extends StatefulWidget {
  const TaskDialoBox({Key? key, required this.id}) : super(key: key);
    final id;
  @override
  State<TaskDialoBox> createState() => _TaskDialoBoxState();
}

class _TaskDialoBoxState extends State<TaskDialoBox> {

  final _formKey = GlobalKey<FormState>();
  final _task_title = TextEditingController();
  final _task_description = TextEditingController();
  final _task_date = TextEditingController();
  List<Map<String, dynamic>> _listTasks = [];

  String people_data = '';

  void loadTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);

    setState(() {
      _listTasks = task_data;
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks(widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Add Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: wp(80, context),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _task_title,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: Colors.transparent,
                    ),
                    labelText: 'Enter Task Title',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
                    // TODO: add errorHint
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Title can't be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                height: hp(4, context),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: wp(80, context),
                child: TextFormField(
                  maxLines: 2,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: _task_description,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: Colors.transparent,
                    ),
                    labelText: 'Enter Task Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,

                    // TODO: add errorHint
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return "Project Description can't be empty";
                    } else {
                      return null;
                    }
                  },
                  onChanged: (_) => setState(() {}),
                ),
              ),
              SizedBox(
                height: hp(4, context),
              ),
              SizedBox(height: 5),
              SizedBox(
                width: wp(80, context),
                child: TextField(
                  controller: _task_date,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.calendar_today,
                      color: Colors.transparent,
                    ),
                    labelText: "Enter Deadline Date",
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true, //label text of field
                  ),
                  readOnly: true,
                  onTap: () async {
                    DateTime? pickedDate1 = await showDatePicker(
                        context: context,
                        initialDate: DateTime.now(),
                        firstDate: DateTime(1950),
                        lastDate: DateTime(2100));
                    if (pickedDate1 != null) {
                      print(
                          pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
                      String formattedDate1 =
                      DateFormat('yMMMd').format(pickedDate1);
                      print(
                          formattedDate1); //formatted date output using intl package =>  2021-03-16
                      setState(() {
                        _task_date.text =
                            formattedDate1; //set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              ),
              SizedBox(height: hp(4, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize:
                        MaterialStateProperty.all(const Size(130, 40)),
                      ),
                      onPressed: (() async {
                        if (_formKey.currentState!.validate()) {
                          await _addTask(widget.id);
                          loadTasks(widget.id);
                        }
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          _task_title.text = "";
                          _task_description.text = "";
                          _task_date.text = "";
                        }
                      }),
                      child: Text("ADD")),
                  ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize:
                        MaterialStateProperty.all(const Size(130, 40)),
                      ),
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text("CANCEL")),
                ],
              ),
              SizedBox(
                height: hp(1, context),
              ),
            ],
          ),
        ),
      ),
    );
  }


  Future<void> _addTask(int id) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createTask(id, _task_title.text, _task_description.text,
        _task_date.text, people_data, current_date);
  }
}
