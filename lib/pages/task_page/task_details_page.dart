import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:intl/intl.dart';
import 'package:kronovo_app/widgets/subtask_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sql_helper.dart';
import '../../responsive.dart';
import '../../widgets/update_subtask_dialog.dart';

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
                showDialog(
                  builder: (context) => SubTaskDialog(id: widget.id),
                  context: context,
                  barrierDismissible: false,
                );
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
                        label: 'Done',
                      ),
                      SlidableAction(
                        autoClose: true,
                        flex: 1,
                        onPressed: (value) {
                          setState(() {
                            showDialog(
                              builder: (context) => UpdateSubTaskDialog(id: _listSubTasks[index]['column_subtasks_id']),
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