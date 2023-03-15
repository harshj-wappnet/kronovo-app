import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/sub_task_pages/sub_task_details_page.dart';
import 'package:kronovo_app/pages/sub_task_pages/add_subtask_page.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../sub_task_pages/update_subtask_page.dart';

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
  String task_title = '';
  String task_description = '';
  String task_enddate = '';
  String task_peoples = '';
  List<String> _selectedItems = [];
  double progress = 0.0;

  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade600,
    Colors.green.shade700,
    Colors.green.shade800,
  ];
  Random random = new Random();

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
        people_data = task_data['tasks_assigned_peoples'].replaceAll('[', '').replaceAll(']','');
        _selectedItems = people_data.split(",");
      });
    }
  }

  void showSubTasks(int id) async {
    final data = await SQLHelper.getAllSubTasksByTask(id);
    setState(() {
      _listSubTasks = data;
    });
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
                showDialog(
                  builder: (context) => AddSubTaskPage(id: widget.id),
                  context: context,
                  barrierDismissible: false,
                );
              },
              icon: Icon(Icons.add))
        ],
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          initState();
        },
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: [
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
                                '$task_title',
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
                                '$task_description',
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
                                margin: EdgeInsets.only(left: 5.0,right: 5.0, top: 5.0),
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
                                'Deadline : $task_enddate',
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
              Text("Sub Tasks", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
              Divider(height: 4.0,),
              SizedBox(height: 10.0,),
              Expanded(
                  child: ListView.builder(
                    primary: false,
                    scrollDirection: Axis.vertical,
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                itemCount: _listSubTasks.length,
                itemBuilder: (context, index) => Container(
                  margin: EdgeInsets.only(left: 20.0,right: 20.0),
                  child: Slidable(
                    enabled: _listSubTasks[index]['is_enable_subtasks'] == 1 ? false : true,
                    key: const ValueKey(0),
                    startActionPane: ActionPane(
                      motion: const DrawerMotion(),
                      children: [
                        SlidableAction(
                          flex: 1,
                          autoClose: true,
                          onPressed: (value) {
                            progress += 0.1;
                            SQLHelper.updateProgressTask(widget.id, progress);
                            SQLHelper.changeValuesSubTask(_listSubTasks[index]['column_subtasks_id'], 1);
                            setState(() {
                              showSubTasks(widget.id);
                            });
                            // SQLHelper.deleteSubTask(
                            //     _listSubTasks[index]['column_subtasks_id']);
                            // showSubTasks(widget.id);
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
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSubTaskPage(id: _listSubTasks[index]['column_subtasks_id'],task_id: widget.id),));
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubTaskDetailsPage(id: _listSubTasks[index]['column_subtasks_id']),));
                      },
                      child: Card(
                        color: _listSubTasks[index]['is_enable_subtasks'] == 1 ? Colors.grey : colors[random.nextInt(4)],
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
                                '${_listSubTasks[index]['subtasks_name']}',
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
                                    'Deadline :  ${_listSubTasks[index]['subtasks_end_date']}',
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
                                      value: _listSubTasks[index]['subtasks_progress'] /
                                          _listSubTasks.length,
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
                                          '${(_listSubTasks[index]['subtasks_progress'] /
                                              _listSubTasks.length * 100).toInt()}%',
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
                                        _listSubTasks[index]['createdAt']))}',
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
              )),
            ],
          ),
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