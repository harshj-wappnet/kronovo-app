import 'dart:convert';
import 'dart:developer';

import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:path/path.dart';
import 'package:kronovo_app/helpers/sql_helper.dart';
import 'package:kronovo_app/pages/home_page.dart';
import 'package:kronovo_app/pages/task_page/add_task.dart';
import 'assign members_dialog.dart';
import 'package:kronovo_app/responsive.dart';
import 'assign members_dialog.dart';
import 'package:sqflite/sqflite.dart';

class UpdateProject extends StatefulWidget {

  final ValueChanged<String> onSubmit;
  final id;

  UpdateProject({super.key, required this.onSubmit, required this.id});


  @override
  State<UpdateProject> createState() => UpdateProjectState();
}

class UpdateProjectState extends State<UpdateProject> {
  //final int id = ModalRoute.of(context)!.settings.arguments as Home_Page();
  final _formKey = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late MultiValueDropDownController cntMulti;

  late final ValueChanged<String> onSubmit;
  late TextEditingController project_title_Controller;
  late TextEditingController _project_description_Controller;
  List<String> _selectedItems = [];
  String people_data = '';


  String _displayText(String begin, DateTime? date) {
    if (date != null) {
      return '$begin Date: ${date.toString().split(' ')[0]}';
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

    /// play with logic
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
    _project_description_Controller = TextEditingController();
    super.initState();
  }

  @override
  void dispose() {
    cntMulti.dispose();
    project_title_Controller.dispose();
    _project_description_Controller.dispose();
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
        _selectedItems.forEach((element) { people_data += element; people_data += ','; });
        //print(people_data);
      });
    }
  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Project'),
        backgroundColor: Colors.green,
      ),
      backgroundColor: Colors.white,
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).requestFocus(new FocusNode());
        },
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  Image.asset('assets/images/createproject_image.jpg', height: 200, width: 300,),
                  Form(
                    key: _formKey,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              SizedBox(height: 5),
                              SizedBox(
                                width: wp(80, context),
                                child: TextFormField(
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  controller: project_title_Controller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Enter Project Title',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    errorText: _submitted ? _errorText1 : null,
                                    // TODO: add errorHint
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
                              SizedBox(
                                height: hp(4, context),
                              ),
                              SizedBox(
                                width: wp(80, context),
                                child: TextFormField(
                                  maxLines: 2,
                                  autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                                  controller: _project_description_Controller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Project Description',
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
                              SizedBox(
                                height: hp(4, context),
                              ),

                              SizedBox(height: 5),
                              SizedBox(
                                width: wp(80, context),
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
                                        _displayText("", startDate);
                                    setState(() {});
                                  },
                                  readOnly: true,
                                  validator: startDateValidator,
                                  style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: hp(4, context),
                              ),
                              SizedBox(
                                width: wp(80, context),
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
                              SizedBox(height: hp(4, context)),
                              ElevatedButton(
                                onPressed: _showMultiSelect,
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 20,color: Colors.white),),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  fixedSize: MaterialStateProperty.all(const Size(350, 40)),
                                ),
                                child: const Text('Assign Peoples'),
                              ),

                              // display selected items
                              Wrap(
                                children: _selectedItems
                                    .map((e) => Chip(
                                  label: Text(
                                    "${e.split(" ")[0][0]}${e.split(" ")[1][0]}",
                                  ),
                                  backgroundColor: Colors.lightGreen,
                                ))
                                    .toList(),
                              ),
                              SizedBox(
                                height: hp(4, context),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  await _addProject(widget.id);
                                  Navigator.pop(context);
                                },
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(fontSize: 20,color: Colors.white),),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  fixedSize: MaterialStateProperty.all(const Size(350, 40)),
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
      ),
    );
  }

  Future<void> _addProject(int pid) async{
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateItem(pid,project_title_Controller.text, _project_description_Controller.text, startDateController.text, endDateController.text, people_data,current_date);
  }
}
