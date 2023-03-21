import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/project_pages/update_project_page.dart';
import 'package:kronovo_app/pages/task_pages/task_details_page.dart';
import 'package:kronovo_app/utils/responsive.dart';
import 'package:kronovo_app/pages/task_pages/add_task_page.dart';
import 'package:kronovo_app/pages/task_pages/update_task_page.dart';
import 'package:kronovo_app/utils/theme.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../databases/sql_helper.dart';
import '../../widgets/confirmation_dialog.dart';

class ProjectDetailsPage extends StatefulWidget {
  const ProjectDetailsPage({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<ProjectDetailsPage> createState() => _ProjectDetailsPageState();
}

class _ProjectDetailsPageState extends State<ProjectDetailsPage> {
  List<Map<String, dynamic>> _listProjects = [];
  List<Map<String, dynamic>> _listTasks = [];
  List<Map<String, dynamic>> _listSubTasks = [];
  List<String> _selectedItems = [];
  String people_data = '';
  int task_id = 0;
  double task_progress = 0.0;
  double progress = 0.0;
  double subtask_count = 0.0;
  String project_title = "";
  String project_description = "";
  String project_enddate = "";
  String project_peoples = "";
  int isenable = 0;
  int counter = 0;
  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade600,
    Colors.green.shade700,
    Colors.green.shade800,
  ];
  Random random = new Random();

  // this method is used for fetch project for display to user
  // we get specific project using project id
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
        people_data = project_data['project_assigned_peoples']
            .replaceAll('[', '')
            .replaceAll(']', '');
        _selectedItems = people_data.split(",");
      });
    }
  }

  Future<void> _loadPref() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      subtask_count = prefs.getDouble('subtask_counter')!;
    });
  }

  // this method is used for fetching all tasks which are under specific project
  // we fetch that using project id.
  void showTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);
    setState(() {
      _listTasks = task_data;
      final existing_task_data =
          _listTasks.firstWhere((element) => element['column_task_id'] == id);
      isenable = existing_task_data['is_enable_tasks'];
      task_id = existing_task_data['column_task_id'];
      task_progress = existing_task_data['tasks_progress'];
      getTotalSubtask(task_id);
    });
  }

  // used for display mileston's total task available in project
  void getTotalSubtask(int id) async {
    final subtask_data = await SQLHelper.getAllSubTasksByTask(id);
    setState(() {
      _listSubTasks = subtask_data;
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showProject(widget.id);
      showTasks(widget.id);
      _loadPref();
    });
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(context,
        MaterialPageRoute(builder: (context) => AddTaskPage(id: widget.id)));
    if (!mounted) return;
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: Colors.white,
        appBar: AppBar(
            title: Text(
              "Project Details",
              style: TextStyle(fontFamily: 'lato'),
            ),
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
                    _navigateforResult(context);
                  },
                  icon: Icon(Icons.add))
            ]),
        body: RefreshIndicator(
          onRefresh: () async {
            initState();
          },
          child: SingleChildScrollView(
            scrollDirection: Axis.vertical,
            child: Column(children: <Widget>[
              Container(
                width: wp(100, context),
                margin: EdgeInsets.only(left: 20.0, right: 20.0),
                child: Column(
                  children: [
                    //Image.asset("assets/images/project_image.jpg",height: 250,width: wp(100, context),fit: BoxFit.fill,),
                    SizedBox(
                      height: 15.0,
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            '$project_title'.toUpperCase(),
                            style: subHeadingStyleblack,
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          padding: EdgeInsets.all(8),
                          child: Text('Description : ', style: titleStyle),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          padding: EdgeInsets.all(8),
                          child: Text('$project_description',
                              style: subtitleStyle),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          padding: EdgeInsets.all(10),
                          child: Text('Members : ', style: titleStyle),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          //padding: EdgeInsets.all(10),
                          child: Wrap(
                            children: _selectedItems
                                .map((e) => Container(
                                      margin: EdgeInsets.only(
                                          left: 5.0, right: 5.0, top: 5.0),
                                      child: Chip(
                                        padding: EdgeInsets.all(8.0),
                                        backgroundColor: Colors.green.shade100,
                                        elevation: 2.0,
                                        label: Text(
                                          "${e.split(",").join()}",
                                          style: TextStyle(
                                              fontSize: 16.0,
                                              fontFamily: 'lato'),
                                        ),
                                      ),
                                    ))
                                .toList(),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(90, context),
                          padding: EdgeInsets.all(10),
                          child: Text('Deadline : ', style: titleStyle),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(70, context),
                          padding: EdgeInsets.all(10),
                          child: Text('$project_enddate', style: subtitleStyle),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 15.0,
                    ),

                    Row(children: [
                      ElevatedButton(
                        onPressed: () {
                          setState(() {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                    builder: (context) =>
                                        UpdateProject(id: widget.id)));
                          });
                        },
                        child: const Text('UPDATE PROJECT'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.blueAccent),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          fixedSize: MaterialStateProperty.all(
                              Size(wp(90, context), 50)),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'lato'),
                          ),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    ]),
                    SizedBox(
                      height: 8.0,
                    ),
                    Row(children: [
                      ElevatedButton(
                        onPressed: () {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return ConfirmationDialog(
                                title: 'Delete Project',
                                content:
                                    'Are you sure you want to delete this Projet ?',
                                onConfirm: () {
                                  SQLHelper.deleteProject(widget.id);
                                  setState(() {
                                    Navigator.pop(context);
                                  });
                                  Navigator.of(context).pop();
                                },
                              );
                            },
                          );
                        },
                        child: const Text('DELETE PROJECT'),
                        style: ButtonStyle(
                          backgroundColor:
                              MaterialStateProperty.all(Colors.red),
                          foregroundColor:
                              MaterialStateProperty.all(Colors.white),
                          textStyle: MaterialStateProperty.all(
                            TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontFamily: 'lato'),
                          ),
                          fixedSize: MaterialStateProperty.all(
                              Size(wp(90, context), 50)),
                          shape: MaterialStateProperty.all(
                            RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                        ),
                      )
                    ]),

                    SizedBox(
                      height: hp(4, context),
                    ),
                    Row(
                      children: [
                        Container(
                          width: wp(70, context),
                          padding: EdgeInsets.all(10),
                          child: Text(
                            'Tasks',
                            style: TextStyle(
                                fontFamily: 'lato',
                                fontSize: 18,
                                fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                    Divider(
                      height: 4.0,
                    ),
                    SizedBox(
                      height: 10.0,
                    ),
                  ],
                ),
              ),
              Container(
                child: _listTasks.isNotEmpty
                    ? ListView.builder(
                        primary: true,
                        scrollDirection: Axis.vertical,
                        physics: NeverScrollableScrollPhysics(),
                        shrinkWrap: true,
                        itemCount: _listTasks.length,
                        itemBuilder: (context, index) => Container(
                          margin: EdgeInsets.only(left: 20.0, right: 20.0),
                          child: Slidable(
                            key: const ValueKey(0),
                            enabled: _listTasks[index]['is_enable_tasks'] == 1
                                ? false
                                : true,
                            startActionPane: ActionPane(
                              motion: const DrawerMotion(),
                              children: [
                                SlidableAction(
                                  flex: 1,
                                  autoClose: true,
                                  onPressed: (value) {
                                    progress += 0.1;
                                    counter += 1;

                                    if (_listTasks[index]["tasks_milestone"] ==
                                        _listSubTasks.length) {
                                      SQLHelper.changeValuesTask(
                                          _listTasks[index]['column_task_id'],
                                          1);
                                      SQLHelper.updateProgressProject(
                                          widget.id, progress, counter);
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.success(
                                          message: 'Task is Completed',
                                        ),
                                      );
                                      setState(() {
                                        showTasks(widget.id);
                                      });
                                    } else {
                                      showTopSnackBar(
                                        Overlay.of(context),
                                        const CustomSnackBar.error(
                                          message:
                                              'All Sub Task Must be completed',
                                        ),
                                      );
                                    }
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
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) => UpdateTaskPage(
                                              id: _listTasks[index]
                                                  ['column_task_id'],
                                              project_id: widget.id),
                                        ));
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
                                                  ['column_task_id'],
                                              project_id: widget.id)));
                                },
                                child: Card(
                                  color:
                                      _listTasks[index]['is_enable_tasks'] == 1
                                          ? Colors.grey
                                          : colors[random.nextInt(4)],
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  elevation: 2,
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 16, vertical: 24),
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              '${_listTasks[index]['tasks_name']}',
                                              style: TextStyle(
                                                fontFamily: 'lato',
                                                color: Colors.white,
                                                fontSize: 24,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.end,
                                              children: [
                                                Icon(
                                                  Icons.task_alt_rounded,
                                                  color: Colors.white,
                                                ),
                                                SizedBox(
                                                  width: 4.0,
                                                ),
                                                Text(
                                                  '${_listTasks[index]["tasks_milestone"]}/${_listSubTasks.length}',
                                                  style: TextStyle(
                                                    fontFamily: 'lato',
                                                    color: Colors.white,
                                                    fontSize: 18,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ],
                                            )
                                          ],
                                        ),
                                        SizedBox(height: 16),
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: [
                                            Text(
                                              'Deadline :  ${_listTasks[index]['tasks_end_date']}',
                                              style: TextStyle(
                                                fontFamily: 'lato',
                                                color: Colors.white
                                                    .withOpacity(0.8),
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
                                                value: _listTasks[index]
                                                        ['tasks_progress'] / subtask_count,
                                                valueColor:
                                                    AlwaysStoppedAnimation<
                                                        Color>(
                                                  Colors.white,
                                                ),
                                                backgroundColor:
                                                    Colors.green.shade100,
                                              ),
                                            ),
                                            Positioned.fill(
                                              child: Align(
                                                alignment:
                                                    Alignment.centerRight,
                                                child: Padding(
                                                  padding:
                                                      const EdgeInsets.only(
                                                          right: 8),
                                                  child: Text(
                                                    '${(_listTasks[index]['tasks_progress'] / subtask_count * 100).toInt()}%',
                                                    style: TextStyle(
                                                      fontFamily: 'lato',
                                                      color: Colors.white,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(
                                          height: 15.0,
                                        ),
                                        Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.end,
                                          mainAxisAlignment:
                                              MainAxisAlignment.end,
                                          children: [
                                            Text(
                                              '${convertToAgo(DateTime.parse(_listTasks[index]['createdAt']))}',
                                              style: TextStyle(
                                                  fontFamily: 'lato',
                                                  fontSize: 12.0,
                                                  color: Colors.white),
                                            )
                                          ],
                                        )
                                      ],
                                    ),
                                  ),
                                )),
                          ),
                        ),
                      )
                    : Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.only(top: hp(3, context)),
                        child: Column(
                          children: <Widget>[
                            Padding(
                              padding: const EdgeInsets.only(left: 20.0),
                              child: Image.asset(
                                  "assets/images/default_icon.png",
                                  height: 120,
                                  width: 120),
                            ),
                            SizedBox(
                              height: 6,
                            ),
                            Text(
                              "NO TASKS",
                              style: TextStyle(fontFamily: 'lato'),
                            ),
                            Text(
                              "Click On + to add Task",
                              style: TextStyle(fontFamily: 'lato'),
                            ),
                          ],
                        ),
                      ),
              ),
            ]),
          ),
        ));
  }

  // this method is used to convert raw time data to (1 day ago) type data.
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
