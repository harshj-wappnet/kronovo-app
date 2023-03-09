import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kronovo_app/pages/task_page/task_details_page.dart';
import 'package:kronovo_app/responsive.dart';
import 'package:kronovo_app/widgets/task_dialog.dart';
import 'package:kronovo_app/widgets/update_task_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sql_helper.dart';
import '../../widgets/assignmembers_dialog.dart';

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
  int? task_id;

  // TextEditingController dateInput1 = TextEditingController();


  double task_progress = 0.0;

  String project_title = "";
  String project_description = "";
  String project_enddate = "";
  String project_peoples = "";

  void _showProject(int? id) async {
    if (id != null) {
      final data = await SQLHelper.getProject(id);

      setState(() {
        _listProjects = data;
        final project_data =
            _listProjects.firstWhere((element) => element['project_id'] == id);
        project_title = project_data['project_name'];
        project_description = project_data['project_description'];
        project_enddate = project_data['project_end_date'];
        _selectedItems = project_data['project_assigned_peoples'].replaceAll('[ ]', '').split(",");
      });
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
      final existing_task_data =
      _listTasks.firstWhere((element) => element['column_task_id'] == id);
      _loadPref(existing_task_data['column_task_id']);
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      _showProject(widget.id);
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
        // _selectedItems.forEach((element) {
        //   people_data += element;
        //   people_data += ',';
        // });
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
              IconButton(
                  onPressed: () {
                    showDialog(
                      builder: (context) => TaskDialoBox(id: widget.id),
                        context: context,
                      barrierDismissible: false
                    );
                  },
                  icon: Icon(Icons.add))
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            initState();
          },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  Text(
                    '$project_title',
                    style: TextStyle(
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                        decoration: TextDecoration.underline),
                  ),
                  SizedBox(
                    height: hp(4, context),
                  ),
                  Text(
                    '$project_description',
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
                  children: _selectedItems
                      .map((e) => Chip(
                    label: Text(
                      "${e}",
                    ),
                  ))
                      .toList(),
              ),
                  SizedBox(
                    height: hp(4, context),
                  ),
                  Text(
                    'deadline :- $project_enddate',
                    style:
                        const TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 20.0,),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
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
                                  SQLHelper.deleteTask(
                                      _listTasks[index]['column_task_id']);
                                  showTasks(widget.id);
                                },
                                backgroundColor: Colors.green,
                                foregroundColor: Colors.white,
                                icon: Icons.check,
                                label: 'Done',
                              ),
                              SlidableAction(
                                autoClose: true,
                                flex: 1,
                                onPressed: (value) {
                                  setState(() {
                                    showDialog(
                                      builder: (context) => UpdateTaskDialog(id: widget.id,task_id: _listTasks[index]['column_task_id']),
                                      context: context,
                                      barrierDismissible: false,
                                    );
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
                                      builder: (context) => TaskDetailsPage(
                                          id: _listTasks[index]
                                              ['column_task_id'])));
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
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text(
                                            '  ${_listTasks[index]['tasks_end_date']}'),
                                      ],
                                    ),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 40.0, right: 20.0),
                                      child: LinearProgressIndicator(
                                        value: task_progress,
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.green),
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
                  ),
        ]),
            ),
        )
    );
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