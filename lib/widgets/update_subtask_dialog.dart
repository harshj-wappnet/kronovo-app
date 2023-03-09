import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

import '../helpers/sql_helper.dart';
import '../responsive.dart';

class UpdateSubTaskDialog extends StatefulWidget {
  const UpdateSubTaskDialog({Key? key, required this.id}) : super(key: key);
  final id;
  @override
  State<UpdateSubTaskDialog> createState() => _UpdateSubTaskDialogState();
}

class _UpdateSubTaskDialogState extends State<UpdateSubTaskDialog> {

  final update_sub_task_title = TextEditingController();
  final update_sub_task_description = TextEditingController();
  final update_sub_task_date = TextEditingController();

  List<Map<String, dynamic>> _listSubTasks = [];
  String people_data = '';

  final _formKey = GlobalKey<FormState>();

  void showSubTasks(int id) async {
    final data = await SQLHelper.getAllSubTasksByTask(id);

    setState(() {
      _listSubTasks = data;
    });
  }

  void loadControlerData(int stid) async {
    if (stid != null) {
      final existingData = _listSubTasks
          .firstWhere((element) => element['column_subtasks_id'] == stid);
      update_sub_task_title.text = existingData['subtasks_name'];
      update_sub_task_description.text = existingData['subtasks_description'];
      update_sub_task_date.text = existingData['subtasks_end_date'];
    }
  }

  @override
  void initState() {
    super.initState();
    showSubTasks(widget.id);
    loadControlerData(widget.id);
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text('Update Sub Task'),
      content: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              SizedBox(
                width: wp(80, context),
                child: TextFormField(
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: update_sub_task_title,
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
                  controller: update_sub_task_description,
                  decoration: InputDecoration(
                    prefixIcon: Icon(
                      Icons.edit_note,
                      color: Colors.transparent,
                    ),
                    labelText: 'Enter Task Description',
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0)),
                    filled: true,
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
                  controller: update_sub_task_date,
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
                        update_sub_task_date.text =
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
                          await _updateSubTask(widget.id);
                        }
                        setState(() {});
                        if (_formKey.currentState!.validate()) {
                          Navigator.pop(context);
                          update_sub_task_title.text = "";
                          update_sub_task_description.text = "";
                          update_sub_task_date.text = "";
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

  Future<void> _updateSubTask(int stid) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateSubTask(
        stid,
        update_sub_task_title.text,
        update_sub_task_description.text,
        update_sub_task_date.text,
        people_data,
        current_date);
  }
}
