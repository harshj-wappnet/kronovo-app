import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/task_pages/task_details_page.dart';
import 'package:kronovo_app/utils/responsive.dart';
import 'package:kronovo_app/pages/task_pages/add_task_page.dart';
import 'package:kronovo_app/pages/task_pages/update_task_page.dart';
import 'package:kronovo_app/utils/theme.dart';
import '../../databases/sql_helper.dart';
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
  int? task_id;

  double task_progress = 0.0;
  double progress = 0.0;

  String project_title = "";
  String project_description = "";
  String project_enddate = "";
  String project_peoples = "";
  int isenable = 0;

  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade600,
    Colors.green.shade700,
    Colors.green.shade800,
  ];
  Random random = new Random();

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
  void showTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);

    setState(() {
      _listTasks = task_data;
      final existing_task_data =
      _listTasks.firstWhere((element) => element['column_task_id'] == id);
      isenable = existing_task_data['is_enable_tasks'];
      task_progress = existing_task_data['tasks_progress'];
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
            title: Text("Project Details"),
            centerTitle: true,
            backgroundColor: Colors.green,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.only(
                bottomRight: Radius.circular(15),
                bottomLeft: Radius.circular(15),
              ),
            ),
            elevation: 0.0,
            actions: [
              IconButton(
                  onPressed: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) => AddTaskPage(id: widget.id),));
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
                  SizedBox(height: 25.0,),
                  Container(
                    width: wp(100, context),
                    margin: EdgeInsets.only(left: 20.0,right: 20.0),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.all(Radius.circular(15)),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.grey,
                          offset: Offset(4,8),
                          blurRadius: 10,
                        )
                      ],
                    ),
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0),
                      child: Column(
                        children: [
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                width: wp(70, context),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '$project_title',
                                  style: headingStyle
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                          Row(
                            children: [
                              Container(
                                width: wp(70, context),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  '$project_description',
                                  style: subHeadingStyle
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                width: wp(70, context),
                                padding: EdgeInsets.all(10),
                                child: Wrap(
                                  children: _selectedItems
                                      .map((e) => Container(
                                    margin: EdgeInsets.only(left: 5.0,right: 5.0),
                                    child: Chip(
                                      padding: EdgeInsets.all(12.0),
                                      backgroundColor: Colors.green.shade100,
                                      elevation: 5.0,
                                      label: Text(
                                        "${e.split(",").join()}",
                                        style: TextStyle(
                                          fontSize: 18.0,
                                        ),
                                      ),
                                    ),
                                  )
                                  )
                                      .toList(),
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 10.0,),
                          Row(
                            children: [
                              Container(
                                width: wp(70, context),
                                padding: EdgeInsets.all(10),
                                child: Text(
                                  'Deadline : $project_enddate',
                                  style: subHeadingStyle
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: 15.0,)
                        ],
                      ),
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
                          enabled: _listTasks[index]['is_enable_tasks'] == 1 ? false : true,
                          startActionPane: ActionPane(
                            motion: const DrawerMotion(),
                            children: [
                              SlidableAction(
                                flex: 1,
                                autoClose: true,
                                onPressed: (value) {
                                  progress += 0.1;
                                  SQLHelper.updateProgressProject(widget.id, progress);
                                  SQLHelper.changeValuesTask(_listTasks[index]['column_task_id'], 1);
                                  setState(() {
                                    showTasks(widget.id);
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
                                  Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTaskPage(id: _listTasks[index]['column_task_id'],project_id: widget.id),));
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
                              color: _listTasks[index]['is_enable_tasks'] == 1 ? Colors.grey : colors[random.nextInt(4)],
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              elevation: 4,
                              child: Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      '${_listTasks[index]['tasks_name']}',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 24,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 16),
                                    Row(
                                      mainAxisAlignment: MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          'Deadline :  ${_listTasks[index]['tasks_end_date']}',
                                          style: TextStyle(
                                            color: Colors.white.withOpacity(0.8),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 16),
                                    Stack(
                                      children: [
                                        SizedBox(
                                          height: 20,
                                          child: LinearProgressIndicator(
                                            value: _listTasks[index]['tasks_progress'] /
                                                _listTasks.length,
                                            valueColor: AlwaysStoppedAnimation<Color>(
                                              Colors.white,
                                            ),
                                            backgroundColor: Colors.green.shade100,
                                          ),
                                        ),
                                        Positioned.fill(
                                          child: Align(
                                            alignment: Alignment.centerRight,
                                            child: Padding(
                                              padding: const EdgeInsets.only(right: 8),
                                              child: Text(
                                                '${(_listTasks[index]['tasks_progress'] /
                                                    _listTasks.length * 100).toInt()}%',
                                                style: TextStyle(
                                                  color: Colors.white,
                                                  fontWeight: FontWeight.bold,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 15.0,),
                                    Row(
                                      crossAxisAlignment: CrossAxisAlignment.end,
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          '${convertToAgo(DateTime.parse(
                                              _listTasks[index]['createdAt']))}',
                                          style: TextStyle(fontSize: 12.0, color: Colors.white),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            )
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