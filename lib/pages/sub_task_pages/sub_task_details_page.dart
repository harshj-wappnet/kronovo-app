import 'package:flutter/material.dart';

import '../../helpers/sql_helper.dart';

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
        //task_peoples = task_data[''];
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
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              '$sub_task_title',
              style: TextStyle(
                  fontSize: 30,
                  fontWeight: FontWeight.bold,
                  decoration: TextDecoration.underline),
            ),
            Text(
              '$sub_task_description',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            Wrap(
              children: List<Widget>.generate(sub_task_peoples.split(',').length - 1,
                      (int i) {
                    return Container(
                      margin: EdgeInsets.all(10.0),
                      child: Chip(
                        label: Text('${sub_task_peoples.split(',')[i]}'),
                      ),
                    );
                  }).toList(),
            ),
            Text(
              'deadline  $sub_task_enddate',
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

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
