import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kronovo_app/pages/task_page/task_details_page.dart';
import 'package:kronovo_app/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sql_helper.dart';
import 'assign members_dialog.dart';

class ProjectDetailsPage extends StatefulWidget {


  const ProjectDetailsPage({Key? key, required this.id}) : super(key: key);
    final id;
  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<Map<String, dynamic>> _listProjects = [];
  List<Map<String, dynamic>> _listTasks = [];
  List<String> _selectedItems = [];
  String people_data = '';
  double progress_value = 0.0;
  final _formKey = GlobalKey<FormState>();

  // TextEditingController dateInput1 = TextEditingController();

   final _task_title = TextEditingController();
   final _task_description = TextEditingController();
   final _task_date = TextEditingController();

  final update_task_title = TextEditingController();
  final update_task_description = TextEditingController();
  final update_task_date = TextEditingController();
  double task_progress = 0.0;

  void _showProject(int? id) async {
    if(id != null){
      final data = await SQLHelper.getProject(id);

      setState(() {
        _listProjects = data;
      });
    }
  }

  void loadControlerData(int tid) async{
    if(tid != null){
      final existingData = _listTasks.firstWhere((element) => element['column_task_id'] == tid);
      update_task_title.text = existingData['tasks_name'];
      update_task_description.text = existingData['tasks_description'];
      update_task_date.text = existingData['tasks_end_date'];
    }
  }

  void loadData(int pid) async{
    if(pid == null){
      final data = _listProjects.firstWhere((element) => element['project_id'] == pid);
      String project_title = data['project_name'];
      String project_description = data['project_description'];
      String project_enddate = data['project_end_date'];
      String project_peoples = data['project_assigned_peoples'];
    }
  }

  Future<void> _loadPref(int tsid) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      task_progress += prefs.getDouble('subtask_$tsid')!;
    });
  }


  Future<void> _completetask(double process_value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('${widget.id}', process_value);
    });
  }

  void showTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);

    setState(() {
      _listTasks = task_data;
      _loadPref(_listTasks[0]['column_task_id']);
    });
  }



  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showProject(widget.id);
      loadData(widget.id);
      showTasks(widget.id);
    });

  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'Akshay Patel',
      'Arti Chauhan',
      'Harsh Jani',
      'Darshit Shah',
      'Apurv Patel',
      'Yassar Qureshi',
      'Aditya Soni',
      'Ram Ghumaliya'
    ];

    final List<String>? results = await showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
        // String data = jsonEncode(_selectedItems);
        _selectedItems.forEach((element) {
          people_data += element;
          people_data += ',';
        });
        //print(people_data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("KRONOVO"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: () {
              _showMyDialog();
            }, icon: Icon(Icons.add))
          ]
      ),
      body:  RefreshIndicator(
            onRefresh: () async{
                initState();
                },
                child: Column(
                  children: [
                    Flexible(
                      child: Container(
                        child: ListView.builder(
                              itemCount: _listProjects.length,
                              itemBuilder: (context, index) => Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                       Text(
                                        '${_listProjects[index]['project_name']}',
                                        style:
                                        TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                                      ),
                                      SizedBox(height: hp(4,context),),
                                      Text(
                                        '${_listProjects[index]['project_description']}',
                                        style:
                                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: hp(4,context),),
                                      // Text(
                                      //   '${_listProjects[index]['assigned_peoples']}',
                                      //   style:
                                      //   TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      // ),
                                      Wrap(
                                        children: List<Widget>.generate(_listProjects[index]['project_assigned_peoples'].split(',').length - 1 , (int i) {
                                          return Chip(
                                            label: Text('${_listProjects[index]['project_assigned_peoples'].split(',')[i]}'),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: hp(4,context),),
                                      Text(
                                        'deadline :- ${_listProjects[index]['project_end_date']}',
                                        style:
                                        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: hp(8,context),),

                                    ]
                                ),
                                ),
                      ),
                    ),
                    Flexible(
                      child: Padding(
                    padding: const EdgeInsets.all(20.0),
                        child: ListView.builder(
                          itemCount: _listTasks.length,
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
                                          progress_value += 0.1;
                                          _completetask(progress_value);
                                        });
                                        SQLHelper.deleteTask(_listTasks[index]['column_task_id']);
                                        showTasks(widget.id);
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
                                          loadControlerData(_listTasks[index]['column_task_id']);
                                          _updateTaskDialog();
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
                                  onTap: () {
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                            builder: (context) => TaskDetailsPage(id :_listTasks[index]['column_task_id'])));
                                  },
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
                                          '${_listTasks[index]['tasks_name']}',
                                          style: TextStyle(
                                              fontSize: 20.0, fontWeight: FontWeight.bold),
                                        ),

                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.center,
                                          children: [
                                            Icon(Icons.calendar_month),
                                            Text('  ${_listTasks[index]['tasks_end_date']}'),
                                          ],
                                        ),
                                        Container(
                                          margin: EdgeInsets.only(left: 40.0, right: 20.0),
                                          child: LinearProgressIndicator(
                                            value: task_progress,
                                            valueColor: AlwaysStoppedAnimation(Colors.green),
                                            minHeight: 10.0,
                                          ),
                                        ),
                                        Row(
                                          mainAxisAlignment: MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${convertToAgo(DateTime.parse(_listTasks[index]['createdAt']))}',
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
                          ),
                        )
                      ),
                  ],
                ),
            )
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
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
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(130, 40)),
                          ),
                          onPressed: (() async {
                            if(_formKey.currentState!.validate()) {
                              await _addTask(widget.id);
                              showTasks(widget.id);
                            }
                            setState(() {
                            });
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
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(130, 40)),
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

  Future<void> _updateTaskDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Update Task'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: wp(80, context),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: update_task_title,
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
                      controller: update_task_description,
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
                      controller: update_task_date,
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
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(130, 40)),
                          ),
                          onPressed: (() async {
                              if (_formKey.currentState!.validate()) {
                                await _updateTask(widget.id);
                                showTasks(widget.id);
                              }
                            setState(() {
                            });
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                              update_task_title.text = "";
                              update_task_description.text = "";
                              update_task_date.text = "";
                            }
                          }),
                          child: Text("UPDATE")),
                      ElevatedButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(130, 40)),
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

  Future<void> _addTask(int id) async{
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createTask(id,_task_title.text, _task_description.text, _task_date.text, people_data, current_date);
  }

  Future<void> _updateTask(int tid) async{
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateTask(tid,update_task_title.text, update_task_description.text, update_task_date.text, people_data,current_date);
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