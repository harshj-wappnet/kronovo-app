import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kronovo_app/pages/task_pages/task_details_page.dart';
import 'package:kronovo_app/utils/responsive.dart';
import 'package:kronovo_app/pages/task_pages/add_task_page.dart';
import 'package:kronovo_app/pages/task_pages/update_task_page.dart';
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

  double task_progress = 0.0;

  String project_title = "";
  String project_description = "";
  String project_enddate = "";
  String project_peoples = "";
  late int list_size = _listTasks.length;

  List<double> prefList = [];
  List<bool> cardEnabledList = [];
  List<Color> cardColorList = [];


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
        people_data = project_data['project_assigned_peoples'].replaceAll('[', '').replaceAll(']','');
        _selectedItems = people_data.split(",");
      });
    }
  }

  Future<void> _loadPref(int tsid) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      task_progress = prefs.getDouble('subtask_$tsid')!;
      prefList.forEach((element) { element = task_progress;});
    });
  }

  Future<void> _completetask(double process_value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('task_${widget.id}', process_value);
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
    cardEnabledList = List.filled(_listTasks.length,true,growable: false);
    cardColorList = List.filled(_listTasks.length,Colors.white,growable: false);
    prefList = List.filled(_listTasks.length, 0.0,growable: false);
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
            title: Text("Project Details"),
            centerTitle: true,
            backgroundColor: Colors.green,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage(id: widget.id),));
                   },
                  icon: Icon(Icons.add))
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            _showProject(widget.id);
            showTasks(widget.id);
          },
            child: SingleChildScrollView(
              scrollDirection: Axis.vertical,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 25.0,),
                  Container(
                    width: wp(100, context),
                    margin: EdgeInsets.only(left: 20.0,right: 20.0),
                    decoration: BoxDecoration(
                      color: Color(0xffbcf5bc),
                      borderRadius: BorderRadius.all(Radius.circular(20)),
                      boxShadow: [
                        BoxShadow(
                            color: Colors.green,
                            offset: Offset(4,8),
                          blurRadius: 12,
                        )
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        SizedBox(height: 8.0,),
                        Text(
                          '$project_title',
                          style: TextStyle(
                            fontSize: 50,
                            color: Colors.white,
                            fontWeight: FontWeight.bold
                          ),
                        ),
                        SizedBox(height: 15.0,),
                        //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                        Text(
                          '$project_description',
                          style: TextStyle(fontSize: 25,
                          color: Colors.white),
                        ),
                        SizedBox(height: 15.0,),
                        Text("Assigned Members", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),),
                        SizedBox(height: 6.0,),
                        Wrap(
                          children: _selectedItems
                              .map((e) => Container(
                            margin: EdgeInsets.only(left: 5.0,right: 5.0),
                            child: Chip(
                              padding: EdgeInsets.all(8.0),
                              backgroundColor: Colors.white,
                              label: Text(
                                "${e.split(",").join()}",
                                style: TextStyle(
                                  fontSize: 16.0,
                                ),
                              ),
                            ),
                          )
                          )
                              .toList(),
                        ),
                        SizedBox(height: 15.0,),
                        Text(
                          'Deadline : $project_enddate',
                          style:
                          const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                        ),
                        SizedBox(height: 15.0,)
                      ],
                    ),
                  ),

                  SizedBox(
                    height: hp(4, context),
                  ),
                  Text("Tasks", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  Divider(height: 4.0,),
                  SizedBox(height: 10.0,),
                  Expanded(
                    child: ListView.builder(
                      scrollDirection: Axis.vertical,
                      shrinkWrap: true,
                      physics: const ClampingScrollPhysics(),
                      itemCount: _listTasks.length,
                      itemBuilder: (context, index) => Container(
                        margin: EdgeInsets.only(left: 20.0,right: 20.0),
                        child: Slidable(
                          key: const ValueKey(0),
                          enabled: cardEnabledList[index],
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
                                    cardEnabledList[index] = false;
                                    cardColorList[index] = Colors.grey;
                                  });
                                  // SQLHelper.deleteTask(
                                  //     _listTasks[index]['column_task_id']);
                                  // showTasks(widget.id);
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTaskPage(id: _listTasks[index]['column_task_id']),));
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
                              color: cardColorList[index],
                              elevation: 5.0,
                              shadowColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                margin: EdgeInsets.all(15.0),
                                padding: EdgeInsets.all(5.0),
                                height: hp(15, context),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    SizedBox(height: 4.0,),
                                    Text(
                                      '${_listTasks[index]['tasks_name']}',
                                      style: TextStyle(
                                          fontSize: 20.0,
                                          fontWeight: FontWeight.bold),
                                    ),
                                    SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Icon(Icons.calendar_month),
                                        Text(
                                            '  ${_listTasks[index]['tasks_end_date']}'),
                                      ],
                                    ),
                                    SizedBox(height: 10.0,),
                                    Container(
                                      margin:
                                          EdgeInsets.only(left: 20.0, right: 20.0),
                                      child: LinearProgressIndicator(
                                        value: prefList[index],
                                        valueColor:
                                            AlwaysStoppedAnimation(Colors.green),
                                        minHeight: 10.0,
                                      ),
                                    ),
                                    SizedBox(height: 15.0,),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${convertToAgo(DateTime.parse(_listTasks[index]['createdAt']))}',
                                          style: TextStyle(fontSize: 12.0),
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
                ]
              ),
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