import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../helpers/sql_helper.dart';
import '../responsive.dart';

class UpdateTaskDialog extends StatefulWidget {
  const UpdateTaskDialog({Key? key, required this.id, required this.task_id}) : super(key: key);
    final id;
    final task_id;
  @override
  State<UpdateTaskDialog> createState() => _UpdateTaskDialogState();
}

class _UpdateTaskDialogState extends State<UpdateTaskDialog> {

  final _formKey = GlobalKey<FormState>();
  final update_task_title = TextEditingController();
  final update_task_description = TextEditingController();
  final update_task_date = TextEditingController();
  String people_data = '';

  List<Map<String, dynamic>> _listTasks = [];

  void loadTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);

    setState(() {
      _listTasks = task_data;
    });
  }

  void loadControlerData(int tid) async {
    setState(() {
      if (tid != null) {
        final existingData =
        _listTasks.firstWhere((element) => element['column_task_id'] == tid);
        update_task_title.text = existingData['tasks_name'];
        update_task_description.text = existingData['tasks_description'];
        update_task_date.text = existingData['tasks_end_date'];
      }
    });
  }

  @override
  void initState() {
    super.initState();
    loadTasks(widget.id);
    loadControlerData(widget.task_id);
  }


  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: wp(80, context),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: update_task_title,
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
                  controller: update_task_description,
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
                  controller: update_task_date,
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
                        update_task_date.text =
                            formattedDate1; //set output date to TextField value.
                      });
                    } else {}
                  },
                ),
              ),
              SizedBox(height: hp(4, context)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize:
                        MaterialStateProperty.all(const Size(130, 40)),
                      ),
                      onPressed: (() async {
                        if (_formKey.currentState!.validate()) {
                          await _updateTask(widget.task_id);
                          //loadTasks(widget.id);
                        }
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          update_task_title.text = "";
                          update_task_description.text = "";
                          update_task_date.text = "";
                        }
                      }),
                      child: Text("UPDATE")),
                  ElevatedButton(
                      style: ButtonStyle(
                        textStyle: MaterialStateProperty.all(
                          TextStyle(fontSize: 20, color: Colors.white),
                        ),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10),
                          ),
                        ),
                        fixedSize:
                        MaterialStateProperty.all(const Size(130, 40)),
                      ),
                      onPressed: (() {
                        Navigator.pop(context);
                      }),
                      child: Text("CANCEL")),
                ],
              ),
              SizedBox(
                height: hp(1, context),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> _updateTask(int tid) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateTask(
        tid,
        update_task_title.text,
        update_task_description.text,
        update_task_date.text,
        people_data,
        current_date);
  }
}