import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/project_page/create_project.dart';
import 'package:kronovo_app/pages/project_page/update_project_page.dart';
import 'package:kronovo_app/pages/project_page/project_details_page.dart';
import 'package:kronovo_app/responsive.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../helpers/sql_helper.dart';

class HomePage extends StatefulWidget {
  const HomePage({Key? key}) : super(key: key);

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> _listProjects = [];
  int? id;
  List<String> _peoplesList = [];
  late final item;
  double project_progress = 0.0;

  Future<void> _loadPref(int pid) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      project_progress += prefs.getDouble('$pid')!;
    });
  }

  void getAllProjects() async {
    final data = await SQLHelper.getProjects();
    setState(() {
      _listProjects = data;
      String peoples = _listProjects[0]['project_assigned_peoples'].toString();
      _peoplesList = peoples.split(',');
      _loadPref(_listProjects[0]['project_id']);
    });
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        CreateProject(onSubmit: (String value) {
          null;
        },)));
    if (!mounted) return;
    initState();
  }


  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance?.addPostFrameCallback((_) {
      getAllProjects();

      print('number of items ${_listProjects.length}');
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(

      appBar: AppBar(
        title: Text('Kronovo'),
        centerTitle: true,
        actions: [
          IconButton(
              onPressed: () {
                _navigateforResult(context);
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: _listProjects.isNotEmpty ? ListView.builder(
          itemCount: _listProjects.length,
          itemBuilder: (context, index) =>
              Container(
                child: Slidable(
                  key: const ValueKey(0),
                  startActionPane: ActionPane(
                    motion: const DrawerMotion(),
                    children: [
                      SlidableAction(
                        flex: 1,
                        autoClose: true,
                        onPressed: (value) {
                          SQLHelper.deleteProject(
                              _listProjects[index]['project_id']);
                          setState(() {
                            getAllProjects();
                          });
                        },
                        backgroundColor: Colors.red,
                        foregroundColor: Colors.white,
                        icon: Icons.delete,
                        label: 'Delete',
                      ),
                      SlidableAction(
                        autoClose: true,
                        flex: 1,
                        onPressed: (value) {
                          //_listProjects.removeAt(index);
                          setState(() {
                            Navigator.push(
                                context, MaterialPageRoute(builder: (context) =>
                                UpdateProject(
                                  id: _listProjects[index]['project_id'],
                                  onSubmit: (String value) {
                                    null;
                                  },)));
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
                              builder: (context) =>
                                  ProjectDetailsPage(
                                      id: _listProjects[index]['project_id'])));
                    },
                    child: Card(
                      color: Colors.white,
                      elevation: 4.0,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                      ),
                      child: Container(
                        margin: EdgeInsets.symmetric(vertical: 15.0),
                        padding: EdgeInsets.all(8.0),
                        height: hp(20, context),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            Text(
                              '${_listProjects[index]['project_name']}',
                              style: TextStyle(
                                  fontSize: 20.0, fontWeight: FontWeight.bold),
                            ),

                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(Icons.calendar_month),
                                Text(
                                    '  ${_listProjects[index]['project_start_date']}'),

                                Icon(Icons.task_alt_outlined),
                                Text(
                                    ' ${_listProjects[index]['project_end_date']}'),
                              ],
                            ),

                            Container(
                              margin: EdgeInsets.only(left: 40.0, right: 20.0),
                              child: LinearProgressIndicator(
                                value: project_progress,
                                valueColor: AlwaysStoppedAnimation(
                                    Colors.green),
                                minHeight: 10.0,
                              ),
                            ),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  '${convertToAgo(DateTime.parse(
                                      _listProjects[index]['createdAt']))}',
                                  style: TextStyle(fontSize: 14.0),
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
        )
            : Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text("NO PROJECTS",
                  style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 28)
              ),
              Text('Click On + to Add Projects',
                  style: TextStyle(
                      color: Colors.grey.shade700,
                      fontSize: 18)
              ),
            ],
          ),
        ),
      ),
    );
  }

  String convertToAgo(DateTime input) {
    Duration diff = DateTime.now().difference(input);
    if (diff.inDays > 365)
      return "${(diff.inDays / 365).floor()} ${(diff.inDays / 365).floor() == 1
          ? "year"
          : "years"} ago   ";
    if (diff.inDays > 30)
      return "${(diff.inDays / 30).floor()} ${(diff.inDays / 30).floor() == 1
          ? "month"
          : "months"} ago   ";
    if (diff.inDays > 7)
      return "${(diff.inDays / 7).floor()} ${(diff.inDays / 7).floor() == 1
          ? "week"
          : "weeks"} ago   ";
    if (diff.inDays > 0)
      return "${diff.inDays} ${diff.inDays == 1 ? "day" : "days"} ago   ";
    if (diff.inHours > 0)
      return "${diff.inHours} ${diff.inHours == 1 ? "hour" : "hours"} ago   ";
    if (diff.inMinutes > 0)
      return "${diff.inMinutes} ${diff.inMinutes == 1
          ? "minute"
          : "minutes"} ago   ";
    return "just now   ";
  }
}