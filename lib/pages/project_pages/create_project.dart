import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:kronovo_app/helpers/sql_helper.dart';
import 'package:kronovo_app/pages/home_page.dart';
import '../../widgets/assignmembers_dialog.dart';
import 'package:kronovo_app/utils/responsive.dart';
import '../../widgets/assignmembers_dialog.dart';
import 'package:sqflite/sqflite.dart';

class CreateProject extends StatefulWidget {

  final ValueChanged<String> onSubmit;

  CreateProject({super.key, required this.onSubmit});

  @override
  State<CreateProject> createState() => _CreateProjectState();
}

class _CreateProjectState extends State<CreateProject> {
  GlobalKey<FormState> _formKey_project = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late MultiValueDropDownController cntMulti;
  late final ValueChanged<String> onSubmit;
  late TextEditingController project_title_Controller;
  late TextEditingController project_description_Controller;
  List<String> _selectedItems = [];
  String people_data = '';


  String _displayText(String begin, DateTime? date) {
    if (date != null) {
      return '$begin ${date.toString().split(' ')[0]}';
    } else {
      return 'Choose The Date';
    }
  }

  final TextEditingController startDateController = TextEditingController(),
      endDateController = TextEditingController();
  DateTime? startDate, endDate;

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }

  String? startDateValidator(value) {
    if (startDate == null) return "select the date";
  }

  String? endDateValidator(value) {
    if (startDate != null && endDate == null) {
      return "select Both data";
    }
    if (endDate == null) return "select the date";
    if (endDate!.isBefore(startDate!)) {
      return "End date must be after startDate";
    }
    return null; // optional while already return type is null
  }

  String? get _errorText1 {
    // at any time, we can get the text from _controller.value.text
    final text = project_title_Controller.value.text;

    // Note: you can do your own custom validation here
    // Move this logic this outside the widget for more testable code
    if (text.trim().isEmpty) {
      return "Project Title can't be empty";
    } else {
      // Return null if the entered password is valid
      return null;
    }
  }

  bool _submitted = false;
  void _submit() {
    // if there is no error text
    setState(() => _submitted = true);
    if (_errorText1 == null) {
      widget.onSubmit(project_title_Controller.value.text);
    }
  }

  @override
  void initState() {
    cntMulti = MultiValueDropDownController();
    startDateController.text = "";
    endDateController.text = "";
    project_title_Controller = TextEditingController();
    project_description_Controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cntMulti.dispose();
    project_title_Controller.dispose();
    project_description_Controller.dispose();
    super.dispose();
  }


  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API
    final List<String> items = [
      'Akshay Patel',
      'Arti Chauhan',
      'Harsh Jani',
      'Darshit Shah',
      'Apurv Patel',
      'Yassar Qureshi',
      'Aditya Soni',
      'Ram Ghumaliya'
    ];

    final List<String>? results = await showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return MultiSelect(items: items);
      },
    );

    // Update UI
    if (results != null) {
      setState(() {
        _selectedItems = results;
        // String data = jsonEncode(_selectedItems);
       // _selectedItems.forEach((element) { people_data += element; people_data += ','; });
        //print(people_data);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Create New Project'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Image.asset('assets/images/createproject_image.jpg', height: 200, width: 300,),
                Form(
                  key: _formKey_project,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Container(
                      margin: EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            SizedBox(
                              width: wp(100, context),
                              child: TextFormField(
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: project_title_Controller,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.edit_note,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Project Title',
                                  hintText: 'Enter Project Title',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                  errorText: _submitted ? _errorText1 : null,
                                ),
                                validator: (value) {
                                  if (value!.isEmpty) {
                                    return "Project Title can't be empty";
                                  } else {
                                    // Return null if the entered password is valid
                                    return null;
                                  }
                                },
                                onChanged: (_) => setState(() {}),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            SizedBox(
                              width: wp(100, context),
                              child: TextFormField(
                                maxLines: 4,
                                autovalidateMode:
                                AutovalidateMode.onUserInteraction,
                                controller: project_description_Controller,
                                decoration: InputDecoration(
                                  prefixIcon: Icon(
                                    Icons.edit_note,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Project Description',
                                  hintText: 'Enter Project Description',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.transparent,
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
                            SizedBox(height: 15.0,),
                            SizedBox(
                              width: wp(100, context),
                              child: TextFormField(
                                controller: startDateController,
                                decoration: InputDecoration(
                                  hintText: 'Choose Start Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'Start Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                ),
                                onTap: () async {
                                  startDate = await pickDate();
                                  startDateController.text =
                                      _displayText("",startDate);
                                  setState(() {});
                                },
                                readOnly: true,
                                validator: startDateValidator,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            SizedBox(
                              width: wp(100, context),
                              child: TextFormField(
                                controller: endDateController,
                                readOnly: true,
                                decoration: InputDecoration(
                                  hintText: 'Choose End Date',
                                  prefixIcon: Icon(
                                    Icons.calendar_today_outlined,
                                    color: Colors.grey,
                                  ),
                                  labelText: 'End Date',
                                  border: OutlineInputBorder(
                                      borderRadius: BorderRadius.circular(8.0)),
                                  fillColor: Colors.transparent,
                                  filled: true,
                                ),
                                onTap: () async {
                                  endDate = await pickDate();
                                  endDateController.text =
                                      _displayText("", endDate);
                                  setState(() {});
                                },
                                validator: endDateValidator,
                                style: const TextStyle(
                                    fontSize: 15,
                                    color: Colors.black),
                              ),
                            ),
                            SizedBox(height: 15.0,),
                            Container(
                              alignment: Alignment.centerLeft,
                              child: ElevatedButton.icon(
                                icon: Icon(Icons.add),
                                onPressed: _showMultiSelect,
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 20,color: Colors.white),),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(const Size(150, 40)),
                                ),
                                label: const Text('Assign Peoples'),
                              ),
                            ),
                            SizedBox(height: 10.0,),
                            // display selected items
                            Wrap(
                              children: _selectedItems
                                  .map((e) => Container(
                                margin: EdgeInsets.only(left: 6.0,right: 6.0),
                                    child: Chip(
                                      padding: EdgeInsets.all(8.0),
                                label: Text(
                                    "${e.split(",").join(" ")}",
                                  style: TextStyle(fontSize: 16.0),
                                ),
                              ),
                                  ))
                                  .toList(),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (_formKey_project.currentState!.validate()) {
                                  await _addProject();
                                  setState(() async{
                                    Navigator.pop(context,'return_value');
                                  });
                                }else{
                                 // _formKey.currentState!.validate();
                                }
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20,color: Colors.white),),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(Size(wp(100, context), 50)),
                              ),
                              child: const Text("Create Project"),
                            ),
                          ]),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _addProject() async{
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createProject(project_title_Controller.text, project_description_Controller.text, startDateController.text, endDateController.text, _selectedItems.toString(),current_date);
  }
}
