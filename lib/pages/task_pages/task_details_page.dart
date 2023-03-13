import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:kronovo_app/pages/sub_task_pages/sub_task_details_page.dart';
import 'package:kronovo_app/pages/sub_task_pages/add_subtask_page.dart';
import '../../helpers/sql_helper.dart';
import '../../utils/responsive.dart';
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
                child: Container(
                  margin: EdgeInsets.only(left: 20.0),
                  child: Column(
                    children: [
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Icon(Icons.text_format, color: Colors.white,size: 35,),
                          Text(
                            'Title',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
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
                              '$task_title',
                              style: TextStyle(fontSize: 26,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                      Row(
                        children: [
                          Icon(Icons.text_snippet, color: Colors.white,size: 35,),
                          Text(
                            'Description',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
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
                              '$task_description',
                              style: TextStyle(fontSize: 22,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Icon(Icons.person, color: Colors.white,size: 35,),
                          Text(
                            'Members',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
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
                                  padding: EdgeInsets.all(6.0),
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
                          ),
                        ],
                      ),
                      SizedBox(height: 10.0,),
                      Row(
                        children: [
                          Icon(Icons.calendar_month, color: Colors.white,size: 35,),
                          Text(
                            'Deadline',
                            style: TextStyle(
                                fontSize: 30,
                                color: Colors.white,
                                fontWeight: FontWeight.bold
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
                              '$task_enddate',
                              style: TextStyle(fontSize: 22,
                                  color: Colors.white),
                            ),
                          ),
                        ],
                      ),
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
                scrollDirection: Axis.vertical,
                shrinkWrap: true,
                physics: const ClampingScrollPhysics(),
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
                        color: _listSubTasks[index]['is_enable_subtasks'] == 1 ? Colors.grey : Colors.white,
                        elevation: 5.0,
                        shadowColor: _listSubTasks[index]['is_enable_subtasks'] == 1 ? Colors.grey : Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8.0),
                        ),
                        child: Container(
                          padding: EdgeInsets.all(4.0),
                          height: hp(16, context),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 4.0,),
                              Text(
                                '${_listSubTasks[index]['subtasks_name']}',
                                style: TextStyle(
                                    fontSize: 20.0, fontWeight: FontWeight.bold),
                              ),
                              SizedBox(height: 8.0,),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Icon(Icons.task_alt_outlined),
                                  Text(
                                      '  ${_listSubTasks[index]['subtasks_end_date']}'),
                                ],
                              ),
                              SizedBox(height: 15.0,),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  Text(
                                    '${convertToAgo(DateTime.parse(_listSubTasks[index]['createdAt']))}',
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