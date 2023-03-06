import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../helpers/sql_helper.dart';
import '../../responsive.dart';

class TaskDetailsPage extends StatefulWidget {
  const TaskDetailsPage({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  State<TaskDetailsPage> createState() => _TaskDetailsPageState();
}

class _TaskDetailsPageState extends State<TaskDetailsPage> {
  List<Map<String, dynamic>> _listTasks = [];
  List<Map<String, dynamic>> _listSubTasks = [];
  double value = 0.0;
  String people_data = '';

  final _formKey = GlobalKey<FormState>();

  // TextEditingController dateInput1 = TextEditingController();

  final _task_title = TextEditingController();
  final _task_description = TextEditingController();
  final _task_date = TextEditingController();


  void _showTask(int? id) async {
    if(id != null){
      final data = await SQLHelper.getTask(id);

      setState(() {
        _listTasks = data;
      });
    }
  }

  void showSubTasks(int id) async {
    final data = await SQLHelper.getAllSubTasksByProject(id);

    setState(() {
      _listSubTasks = data;
    });
  }

  Future<void> _completetask(double process_value) async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      prefs.setDouble('process_value', process_value);
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
          IconButton(onPressed: () {
            _showMyDialog();
          }, icon: Icon(Icons.add))
        ],
      ),
      body: SafeArea(
        child: Column(
          children: [
            Flexible(
              child: Container(
                child: ListView.builder(
                  itemCount: _listTasks.length,
                  itemBuilder: (context, index) => Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          '${_listTasks[index]['tasks_name']}',
                          style:
                          TextStyle(fontSize: 30, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),
                        ),
                        SizedBox(height: hp(4,context),),
                        Text(
                          '${_listTasks[index]['tasks_description']} ${_listTasks.length}',
                          style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: hp(4,context),),
                        // Text(
                        //   '${_listProjects[index]['assigned_peoples']}',
                        //   style:
                        //   TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        // ),
                        Wrap(
                          children: List<Widget>.generate(_listTasks[index]['tasks_assigned_peoples'].split(',').length - 1, (int i) {
                            return Chip(
                              label: Text('${_listTasks[index]['tasks_assigned_peoples'].split(',')[i]}'),
                            );
                          }).toList(),
                        ),
                        SizedBox(height: hp(4,context),),
                        Text(
                          'deadline :- ${_listTasks[index]['tasks_end_date']}',
                          style:
                          TextStyle(fontSize: 25, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: hp(8,context),),
                        ElevatedButton(onPressed: () {
                          value += 0.1;
                          _completetask(value);
                        }, child: Text('Completed')),
                      ]
                  ),
                ),
              ),
            ),
            Flexible(
              child: Container(
                  child: ListView.builder(
                    itemCount: _listSubTasks.length,
                    itemBuilder: (context, index) => Container(
                      width: wp(20, context),
                      height: hp(20, context),
                      child: InkWell(
                        onTap: () {
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => TaskDetailsPage(id :_listSubTasks[index]['column_subtasks_id'])));
                        },
                        child: Card(
                          color: Colors.white,
                          elevation: 2.0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                          child: Container(
                            width: wp(20, context),
                            height: hp(20, context),
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
                                    Text('  ${_listSubTasks[index]['subtasks_end_date']}'),
                                  ],
                                ),

                                Container(
                                  margin: EdgeInsets.only(left: 40.0, right: 40.0),
                                  child: LinearProgressIndicator(
                                    value: 0.7,
                                    valueColor: AlwaysStoppedAnimation(Colors.green),
                                    minHeight: 10.0,
                                  ),
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
                  )
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showMyDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Add Sub Task'),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                children: <Widget>[
                  SizedBox(
                    width: wp(80, context),
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _task_title,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.edit_note,
                          color: Colors.transparent,
                        ),
                        labelText: 'Enter Task Title',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        filled: true,
                        // TODO: add errorHint
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Title can't be empty";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    height: hp(4, context),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: wp(80, context),
                    child: TextFormField(
                      maxLines: 2,
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      controller: _task_description,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.edit_note,
                          color: Colors.transparent,
                        ),
                        labelText: 'Enter Task Description',
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        filled: true,

                        // TODO: add errorHint
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Project Description can't be empty";
                        } else {
                          return null;
                        }
                      },
                      onChanged: (_) => setState(() {}),
                    ),
                  ),
                  SizedBox(
                    height: hp(4, context),
                  ),
                  SizedBox(height: 5),
                  SizedBox(
                    width: wp(80, context),
                    child: TextField(
                      controller: _task_date,
                      decoration: InputDecoration(
                        prefixIcon: Icon(
                          Icons.calendar_today,
                          color: Colors.transparent,
                        ),
                        labelText: "Enter Deadline Date",
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(8.0)),
                        filled: true, //label text of field
                      ),
                      readOnly: true,
                      onTap: () async {
                        DateTime? pickedDate1 = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(1950),
                            lastDate: DateTime(2100));
                        if (pickedDate1 != null) {
                          print(
                              pickedDate1); //pickedDate output format => 2021-03-10 00:00:00.000
                          String formattedDate1 =
                          DateFormat('yMMMd').format(pickedDate1);
                          print(
                              formattedDate1); //formatted date output using intl package =>  2021-03-16
                          setState(() {
                            _task_date.text =
                                formattedDate1; //set output date to TextField value.
                          });
                        } else {}
                      },
                    ),
                  ),
                  SizedBox(height: hp(4, context)),
                  SizedBox(
                    height: hp(4, context),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(200, 30)),
                          ),
                          onPressed: (() async {
                            await _addSubTask(widget.id);
                            showSubTasks(widget.id);

                            setState(() {

                            });
                            if (_formKey.currentState!.validate()) {
                              Navigator.pop(context);
                            }
                          }),
                          child: Text("Add Sub Task")),
                      ElevatedButton(
                          style: ButtonStyle(
                            textStyle: MaterialStateProperty.all(
                              TextStyle(fontSize: 20,color: Colors.white),),
                            shape: MaterialStateProperty.all(
                              RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                            ),
                            fixedSize: MaterialStateProperty.all(const Size(100, 30)),
                          ),
                          onPressed: (() {
                            Navigator.pop(context);
                          }),
                          child: Text("Cancel")),
                    ],
                  ),
                  SizedBox(
                    height: hp(4, context),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }



  Future<void> _addSubTask(int id) async{
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createSubTask(id,_task_title.text, _task_description.text, _task_date.text, people_data, current_date);
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
