import 'package:flutter/material.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

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
                              '$sub_task_title',
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
                              '$sub_task_description',
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
                              'Deadline : $sub_task_enddate',
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
          ],
        ),
      ),
    );
  }
}
