import 'package:flutter/material.dart';
import 'package:kronovo_app/pages/sub_task_pages/update_subtask_page.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

class SubTaskDetailsPage extends StatefulWidget {
  const SubTaskDetailsPage({Key? key, required this.id, required this.task_id}) : super(key: key);
  final id;
  final task_id;
  @override
  State<SubTaskDetailsPage> createState() => _SubTaskDetailsPageState();
}

class _SubTaskDetailsPageState extends State<SubTaskDetailsPage> {

  List<Map<String, dynamic>> _listSubTasks = [];
  String people_data = '';
  String sub_task_title = '';
  String sub_task_description = '';
  String sub_task_enddate = '';
  String sub_task_peoples = '';
  List<String> _selectedItems = [];

  void _showSubTask(int? id) async {
    if (id != null) {
      final data = await SQLHelper.getSubTask(id);
      setState(() {
        _listSubTasks = data;
        final sub_task_data =
        _listSubTasks.firstWhere((element) => element['column_subtasks_id'] == id);
        sub_task_title = sub_task_data['subtasks_name'];
        sub_task_description = sub_task_data['subtasks_description'];
        sub_task_enddate = sub_task_data['subtasks_end_date'];
        people_data = sub_task_data['subtasks_assigned_peoples'].replaceAll('[', '').replaceAll(']','');
        _selectedItems = people_data.split(",");
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _showSubTask(widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text('Sub Task Details'),
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        elevation: 0.0,
      ),
      body: SingleChildScrollView(
        scrollDirection: Axis.vertical,
        child: Column(
          children: [
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
                              '$sub_task_title'.toUpperCase(),
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
                              '$sub_task_description',
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
                              '$sub_task_enddate',
                              style: subtitleStyle
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 15.0,),

                    Row(children: [
                      ElevatedButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => UpdateSubTaskPage(id: widget.id,task_id: widget.task_id),));
                        },
                        child: const Text('UPDATE SUB TASK'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.blueAccent),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          fixedSize: MaterialStateProperty.all(Size(wp(90, context), 50)),
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
                          SQLHelper.deleteSubTask(widget.id);
                          setState(() {
                            Navigator.pop(context);
                          });
                        },
                        child: const Text('DELETE SUB TASK'),
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red),
                          foregroundColor: MaterialStateProperty.all(Colors.white),
                          fixedSize: MaterialStateProperty.all(Size(wp(90, context), 50)),
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
                      height: hp(15, context),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}