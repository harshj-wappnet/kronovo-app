import 'package:flutter/material.dart';

import '../../helpers/sql_helper.dart';
import '../../utils/responsive.dart';

class SubTaskDetailsPage extends StatefulWidget {
  const SubTaskDetailsPage({Key? key, required this.id}) : super(key: key);
  final id;
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
      appBar: AppBar(
        title: Text('Sub Task Details'),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
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
                            '$sub_task_title',
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
                            '$sub_task_description',
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
                            '$sub_task_enddate',
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
          ],
        ),
      ),
    );
  }
}
