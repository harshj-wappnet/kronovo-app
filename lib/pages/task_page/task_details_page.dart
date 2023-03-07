import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sql_helper.dart';
import '../../responsive.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  List<Map<String, dynamic>> _listTasks = [];
  List<Map<String, dynamic>> _listSubTasks = [];
  String people_data = '';
  double subtask_progress = 0.0;
  String task_title = '';
  String task_description = '';
  String task_enddate = '';
  String task_peoples = '';

  final _formKey = GlobalKey<FormState>();

  // TextEditingController dateInput1 = TextEditingController();

  final sub_task_title = TextEditingController();
  final sub_task_description = TextEditingController();
  final sub_task_date = TextEditingController();

  final update_sub_task_title = TextEditingController();
  final update_sub_task_description = TextEditingController();
  final update_sub_task_date = TextEditingController();

  void _showTask(int? id) async {
    if (id != null) {
      final data = await SQLHelper.getTask(id);
      setState(() {
        _listTasks = data;
        final task_data =
            _listTasks.firstWhere((element) => element['column_task_id'] == id);
        task_title = task_data['tasks_name'];
        task_description = task_data['tasks_description'];
        task_enddate = task_data['tasks_end_date'];
        //task_peoples = task_data[''];
      });
    }
  }

  void showSubTasks(int id) async {
    final data = await SQLHelper.getAllSubTasksByTask(id);

    setState(() {
      _listSubTasks = data;
    });
  }

  Future<void> _completeSubTask(double process_value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('subtask_${widget.id}', process_value);
    });
  }

  void loadControlerData(int stid) async {
    if (stid != null) {
      final existingData = _listSubTasks
          .firstWhere((element) => element['column_subtasks_id'] == stid);
      update_sub_task_title.text = existingData['subtasks_name'];
      update_sub_task_description.text = existingData['subtasks_description'];
      update_sub_task_date.text = existingData['subtasks_end_date'];
    }
  }

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showTask(widget.id);
      showSubTasks(widget.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Task Details'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _showMyDialog();
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
            Text(
              '$task_title',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            SizedBox(
              height: hp(4, context),
            ),
            Text(
              '$task_description',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: hp(4, context),
            ),
            // Text(
            //   '${_listProjects[index]['assigned_peoples']}',
            //   style:
            //   TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            // ),
            Wrap(
              children: List<Widget>.generate(task_peoples.split(',').length - 1,
                  (int i) {
                return Chip(
                  label: Text('${task_peoples.split(',')[i]}'),
                );
              }).toList(),
            ),
            SizedBox(
              height: hp(4, context),
            ),
            Text(
              'deadline :- $task_enddate',
              style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
            ),
            SizedBox(
              height: hp(8, context),
            ),
            Expanded(
                child: ListView.builder(
              scrollDirection: Axis.vertical,
              shrinkWrap: true,
              physics: const ClampingScrollPhysics(),
              itemCount: _listSubTasks.length,
              itemBuilder: (context, index) => Container(
                child: Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        autoClose: true,
                        onPressed: (value) {
                          setState(() {
                            subtask_progress += 0.1;
                            _completeSubTask(subtask_progress);
                          });
                          SQLHelper.deleteSubTask(
                              _listSubTasks[index]['column_subtasks_id']);
                          showSubTasks(widget.id);
                        },
                        backgroundColor: Colors.green,
                        foregroundColor: Colors.white,
                        icon: Icons.check,
                        label: 'Complete',
                      ),
                      SlidableAction(
                        autoClose: true,
                        flex: 1,
                        onPressed: (value) {
                          setState(() {
                            loadControlerData(
                                _listSubTasks[index]['column_subtasks_id']);
                            _updateSubTaskDialog();
                          });
                        },
                        backgroundColor: Colors.blueAccent,
                        foregroundColor: Colors.white,
                        icon: Icons.edit,
                        label: 'Edit',
                      ),
                    ],
                  ),
                  child: InkWell(
                    onTap: () {},
                    child: Card(
                      color: Colors.white,
                      elevation: 2.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Text(
                              '${_listSubTasks[index]['subtasks_name']}',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                    '  ${_listSubTasks[index]['subtasks_end_date']}'),
                              ],
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${convertToAgo(DateTime.parse(_listSubTasks[index]['createdAt']))}',
                                  style: TextStyle(fontSize: 11.0),
                                )
                              ],
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            )),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Sub Task'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: wp(80, context),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: sub_task_title,
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
                      controller: sub_task_description,
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
                      controller: sub_task_date,
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
                            sub_task_date.text =
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
                              await _addSubTask(widget.id);
                              showSubTasks(widget.id);
                            }
                            setState(() {});
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              sub_task_title.text = "";
                              sub_task_description.text = "";
                              sub_task_date.text = "";
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
                    height: hp(4, context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> _updateSubTaskDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Sub Task'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: wp(80, context),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: update_sub_task_title,
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
                      controller: update_sub_task_description,
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
                      controller: update_sub_task_date,
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
                            sub_task_date.text =
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
                              await _updateSubTask(widget.id);
                              showSubTasks(widget.id);
                            }
                            setState(() {});
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              update_sub_task_title.text = "";
                              update_sub_task_description.text = "";
                              update_sub_task_date.text = "";
                            }
                          }),
                          child: Text("UPDATE")),
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
      },
    );
  }

  Future<void> _addSubTask(int id) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createSubTask(
        id,
        sub_task_title.text,
        sub_task_description.text,
        sub_task_date.text,
        people_data,
        current_date);
  }

  Future<void> _updateSubTask(int stid) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateSubTask(
        stid,
        update_sub_task_title.text,
        update_sub_task_description.text,
        update_sub_task_date.text,
        people_data,
        current_date);
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);

    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1 ? "year" : "years"} ago   ";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1 ? "month" : "months"} ago   ";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1 ? "week" : "weeks"} ago   ";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago   ";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago   ";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1 ? "minute" : "minutes"} ago   ";
    return "just now   ";
  }
}
