import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:kronovo_app/pages/task_page/add_task.dart';
import 'package:kronovo_app/responsive.dart';

import '../helpers/sql_helper.dart';

class ProjectDetailsPage extends StatefulWidget {


  const ProjectDetailsPage({Key? key, required this.id}) : super(key: key);
    final id;
  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<Map<String, dynamic>> _listProjects = [];
  List<Map<String, dynamic>> _listTasks = [];



  void _showProject(int? id) async {
    if(id != null){
      final data = await SQLHelper.getProject(id);

      setState(() {
        _listProjects = data;
      });
    }
  }

  void showTasks(int id) async {
    final task_data = await SQLHelper.getTask(id);

    setState(() {
      _listTasks = task_data;
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          title: Text("KRONOVO"),
          backgroundColor: Colors.green,
          actions: [
            IconButton(onPressed: () {
              Navigator.push(context,
                  MaterialPageRoute(builder: (context) => Add_Task(
                    onSubmit: (String value) {
                      null;
                    },
                  )));
            }, icon: Icon(
              Icons.add,
            )),
          ]
      ),
      body:  SafeArea(
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
                                        '${_listProjects[index]['project_description']} ${_listTasks.length}',
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
                                        children: List<Widget>.generate(_listProjects[index]['project_assigned_peoples'].split(',').length, (int i) {
                                          return Chip(
                                            label: Text('${_listProjects[index]['project_assigned_peoples'].split(',')[i]}'),
                                          );
                                        }).toList(),
                                      ),
                                      SizedBox(height: hp(4,context),),
                                      Text(
                                        'deadline :- ${_listProjects[index]['project_end_date']}',
                                        style:
                                        TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                                      ),
                                      SizedBox(height: hp(8,context),),

                                    ]
                                ),
                                ),
                      ),
                    ),
                    Flexible(
                      child: Container(
                        child: ListView.builder(
                          itemCount: _listTasks.length,
                          itemBuilder: (context, index) => Container(
                            width: wp(20, context),
                            height: hp(20, context),
                            child: InkWell(
                              onTap: () {
                                Navigator.push(
                                    context,
                                    MaterialPageRoute(
                                        builder: (context) => ProjectDetailsPage(id :_listTasks[index]['column_task_id'])));
                              },
                            child: Card(
                              color: Colors.white,
                              elevation: 2.0,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(8.0),
                              ),
                              child: Container(
                                width: wp(20, context),
                                height: hp(20, context),
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
                                      margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                      child: LinearProgressIndicator(
                                        value: 0.7,
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
                        )
                      ),
                    ),
                  ],
                ),
              ),
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