import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kronovo_app/helpers/sql_helper.dart';
import '../../widgets/assignmembers_dialog.dart';
import 'package:kronovo_app/utils/responsive.dart';

class UpdateProject extends StatefulWidget {

  final ValueChanged<String> onSubmit;
  final id;

  UpdateProject({super.key, required this.onSubmit, required this.id});


  @override
  State<UpdateProject> createState() => UpdateProjectState();
}

class UpdateProjectState extends State<UpdateProject> {
  final _formKey_update_project = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late MultiValueDropDownController cntMulti;

  late final ValueChanged<String> onSubmit;

  // late TextEditingController project_title_Controller;
  // late TextEditingController _project_description_Controller;
  List<String> _selectedItems = [];
  String people_data = '';
  List<Map<String, dynamic>> _listProjects = [];
  List<String> _peoplesList = [];


  void getProjectData(int id) async {
    final data = await SQLHelper.getProjects();
    setState(() {
      _listProjects = data;
      String peoples = _listProjects[0]['project_assigned_peoples'].toString();
      _peoplesList = peoples.split(',');
      if (id != null) {
        final existingList = _listProjects.firstWhere((
            element) => element['project_id'] == id);
        project_title_Controller.text = existingList['project_name'];
        _project_description_Controller.text =
        existingList['project_description'];
        startDateController.text = existingList['project_start_date'];
        endDateController.text = existingList['project_end_date'];
        people_data = existingList['project_assigned_peoples']
            .replaceAll('[', '')
            .replaceAll(']', '');
        _selectedItems = people_data.split(",");
      }
    });
  }


  String _displayText(String begin, DateTime? date) {
    if (date != null) {
      return '$begin ${date.toString().split(' ')[0]}';
    } else {
      return 'Choose The Date';
    }
  }

  final TextEditingController startDateController = TextEditingController(),
      endDateController = TextEditingController();
  final project_title_Controller = TextEditingController();
  final _project_description_Controller = TextEditingController();

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
    if (text
        .trim()
        .isEmpty) {
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
    super.initState();
    getProjectData(widget.id);
    cntMulti = MultiValueDropDownController();
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
        //_selectedItems.forEach((element) { people_data += element; people_data += ','; });
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
                  SizedBox(height: 8.0,),
                  Image.asset(
                    'assets/images/createproject_image.jpg', height: 200,
                    width: 300,),
                  Form(
                    key: _formKey_update_project,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0,right: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(height: 5),
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
                                    labelText: 'Title',
                                    hintText: 'Enter Title',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    errorText: _submitted ? _errorText1 : null,
                                    // TODO: add errorHint
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Title can't be empty";
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
                                  controller: _project_description_Controller,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Description',
                                    hintText: 'Enter Description',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Description can't be empty";
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
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
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
                                        borderRadius: BorderRadius.circular(
                                            8.0)),
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
                              ElevatedButton(
                                onPressed: _showMultiSelect,
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(
                                        fontSize: 20, color: Colors.white),),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                      const Size(150, 40)),
                                ),
                                child: const Text('Assign Peoples'),
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
                              SizedBox(
                                height: hp(4, context),
                              ),
                              ElevatedButton(
                                onPressed: () async {
                                  if (_formKey_update_project.currentState!
                                      .validate()) {
                                    await _updateProject(widget.id);
                                    Navigator.pop(context, 'result_value');
                                  }
                                },
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(
                                        fontSize: 20, color: Colors.white),),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                      Size(wp(100, context), 40)),
                                ),
                                child: const Text("Update Project"),
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

  Future<void> _updateProject(int pid) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.updateProject(
        pid,
        project_title_Controller.text,
        _project_description_Controller.text,
        startDateController.text,
        endDateController.text,
        _selectedItems.toString(),
        current_date);
  }
}