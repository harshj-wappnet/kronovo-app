import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/sub_task_pages/sub_task_details_page.dart';
import 'package:kronovo_app/pages/sub_task_pages/add_subtask_page.dart';
import 'package:kronovo_app/pages/task_pages/update_task_page.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../widgets/confirmation_dialog.dart';
import '../sub_task_pages/update_subtask_page.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({Key? key, required this.id, required this.project_id}) : super(key: key);
  final id;
  final project_id;

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
  int counter = 0;

  final List<Color> colors = [
    Colors.green.shade400,
    Colors.green.shade500,
    Colors.green.shade600,
    Colors.green.shade700,
    Colors.green.shade800,
  ];
  Random random = new Random();

  // used fetch specific task data from task table using task id
  void _showTask(int id) async {
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

  // used to fetch all subtask record in subtask table which fall under specific task
  // we fetch using task id
  void showSubTasks(int id) async {
    final data = await SQLHelper.getAllSubTasksByTask(id);
    setState(() {
      _listSubTasks = data;
    });
  }

  final completeSnackBar = SnackBar(
    content:   Row(
      children: [
        Icon(
          Icons.celebration,
          color: Colors.green,
        ),Text('      Task is Completed', style: TextStyle(fontFamily: 'lato',color: Colors.black),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _showTask(widget.id);
      showSubTasks(widget.id);
    });
  }

  Future<void> _navigateforResult(BuildContext context) async {
    final result = await Navigator.push(
        context, MaterialPageRoute(builder: (context) =>
        AddSubTaskPage(id: widget.id)));
     if (!mounted) return;
    initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Task Details', style:  TextStyle(fontFamily: 'lato'),),
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
                _navigateforResult(context);
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
            children: <Widget>[
              Container(
                width: wp(100, context),
                margin: EdgeInsets.only(left: 20.0,),
                child: Container(
                  child: Column(
                    children: [
                      //Image.asset("assets/images/tasks_image.jpg",height: 230,width: wp(100, context),fit: BoxFit.fill,),
                      SizedBox(height: 15.0,),
                      Row(
                        children: [
                          Container(
                            width: wp(90, context),
                            padding: EdgeInsets.all(10),
                            child: Text(
                                '$task_title'.toUpperCase(),
                                style: subHeadingStyleblack
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Container(
                            width: wp(90, context),
                            padding: EdgeInsets.all(8),
                            child: Text(
                                'Description : ',
                                style: titleStyle
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: wp(90, context),
                            padding: EdgeInsets.all(8),
                            child: Text(
                                '$task_description',
                                style: subtitleStyle
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Container(
                            width: wp(90, context),
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Members : ',
                                style: titleStyle
                            ),
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
                                margin: EdgeInsets.only(left: 5.0,right: 5.0, top: 5.0),
                                child: Chip(
                                  padding: EdgeInsets.all(8.0),
                                  backgroundColor: Colors.green.shade100,
                                  elevation: 2.0,
                                  label: Text(
                                    "${e.split(",").join()}",
                                    style:  TextStyle(
                                      fontFamily: 'lato',
                                      fontSize: 16.0,
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
                            width: wp(90, context),
                            padding: EdgeInsets.all(10),
                            child: Text(
                                'Deadline : ',
                                style: titleStyle
                            ),
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Container(
                            width: wp(90, context),
                            padding: EdgeInsets.all(10),
                            child: Text(
                                '$task_enddate',
                                style: subtitleStyle
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 15.0,),

                      Row(children: [
                        ElevatedButton(
                          onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateTaskPage(id: widget.id,project_id: widget.project_id),));
                          },
                          child: const Text('UPDATE TASK'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            fixedSize: MaterialStateProperty.all(Size(wp(90, context), 50)),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontFamily: 'lato',fontSize: 16,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        )
                      ]
                      ),
                      SizedBox(height: 8.0,),
                      Row(children: [
                        ElevatedButton(
                          onPressed: () {
                            showDialog(
                              context: context,
                              builder: (BuildContext context) {
                                return ConfirmationDialog(
                                  title: 'Delete Project',
                                  content: 'Are you sure you want to delete this Projet ?',
                                  onConfirm: () {
                                    SQLHelper.deleteTask(widget.id);
                                    setState(() {
                                      Navigator.pop(context);
                                    });
                                    Navigator.of(context).pop();
                                  },
                                );
                              },
                            );
                          },
                          child: const Text('DELETE TASK'),
                          style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red),
                            foregroundColor: MaterialStateProperty.all(Colors.white),
                            fixedSize: MaterialStateProperty.all(Size(wp(90, context), 50)),
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontFamily: 'lato',fontSize: 16,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              ),
                            ),
                          ),
                        )
                      ]
                      ),

                      SizedBox(
                        height: hp(4, context),
                      ),
                      Row(
                        children: [
                          Container(
                            width: wp(70, context),
                            padding: EdgeInsets.all(10),
                            child: Text(
                              'Sub Tasks',
                              style:TextStyle(fontFamily: 'lato',fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                          ),
                        ],
                      ),
                      Divider(height: 4.0,),
                      SizedBox(height: 10.0,),
                    ],
                  ),
                ),
              ),
              Container(
                  child: _listSubTasks.isNotEmpty ? ListView.builder(
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
                            counter += 1;
                            SQLHelper.updateProgressTask(widget.id, progress,counter);
                            SQLHelper.changeValuesSubTask(_listSubTasks[index]['column_subtasks_id'], 1);
                            ScaffoldMessenger.of(context).showSnackBar(completeSnackBar);
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
                        Navigator.push(context, MaterialPageRoute(builder: (context) => SubTaskDetailsPage(id: _listSubTasks[index]['column_subtasks_id'], task_id : widget.id)));
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
                                  fontFamily: 'lato',
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
                                      fontFamily: 'lato',
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
                                          _listSubTasks.length.toDouble(),
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
                                            fontFamily: 'lato',
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
                                    style: TextStyle(fontFamily: 'lato',fontSize: 12.0, color: Colors.white),
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
              ) : Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.only(top: hp(3, context)),
                    child: Column(
                      children: <Widget>[
                        Padding(
                          padding: const EdgeInsets.only(left: 20.0),
                          child: Image.asset("assets/images/default_icon.png", height: 100,width: 100),
                        ),
                        SizedBox(height: 6,),
                        Text("NO SUB TASKS", style: TextStyle(fontFamily: 'lato'),),
                        Text("Click On + to add Sub Task", style: TextStyle(fontFamily: 'lato'),),
                      ],
                    ),
                  ),
              ),
            ],
          ),
        ),
      ),
    );
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