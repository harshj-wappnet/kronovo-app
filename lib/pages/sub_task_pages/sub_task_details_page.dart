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
              child: Column(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  SizedBox(height: 8.0,),
                  Text(
                    '$sub_task_title',
                    style: TextStyle(
                        fontSize: 50,
                        color: Colors.white,
                        fontWeight: FontWeight.bold
                    ),
                  ),
                  SizedBox(height: 15.0,),
                  //Text("Description", style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),),
                  Text(
                    '$sub_task_description',
                    style: TextStyle(fontSize: 25,
                        color: Colors.white),
                  ),
                  SizedBox(height: 15.0,),
                  Text("Assigned Members", style: TextStyle(color: Colors.white,fontSize: 20, fontWeight: FontWeight.bold,),),
                  SizedBox(height: 6.0,),
                  Wrap(
                    children: _selectedItems
                        .map((e) => Container(
                      margin: EdgeInsets.only(left: 5.0,right: 5.0),
                      child: Chip(
                        padding: EdgeInsets.all(8.0),
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
                  SizedBox(height: 15.0,),
                  Text(
                    'Deadline : $sub_task_enddate',
                    style:
                    const TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),
                  ),
                  SizedBox(height: 15.0,)
                ],
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
