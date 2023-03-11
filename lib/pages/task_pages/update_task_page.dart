import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../../helpers/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../widgets/assignmembers_dialog.dart';

class UpdateTaskPage extends StatefulWidget {
  const UpdateTaskPage({Key? key, required this.id}) : super(key: key);
    final id;
  @override
  State<UpdateTaskPage> createState() => _UpdateTaskPageState();
}

class _UpdateTaskPageState extends State<UpdateTaskPage> {

  final _formKey_update_task = GlobalKey<FormState>();
  final update_task_title = TextEditingController();
  final update_task_description = TextEditingController();
  final update_task_date = TextEditingController();
  String people_data = '';
  List<String> _selectedItems = [];

  List<Map<String, dynamic>> _listTasks = [];

  void loadTasks(int id) async {
    final task_data = await SQLHelper.getAllTasksByProject(id);
    setState(() {
      _listTasks = task_data;
      final existingData =
      _listTasks.firstWhere((element) => element['column_task_id'] == id);
      update_task_title.text = existingData['tasks_name'];
      update_task_description.text = existingData['tasks_description'];
      update_task_date.text = existingData['tasks_end_date'];
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
    final text = update_task_title.value.text;

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
    }
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
  void initState() {
    super.initState();
    loadTasks(widget.id);
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Task'),
        centerTitle: true,
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
                  Image.asset('assets/images/tasks_image.jpg', height: 200, width: 300,),
                  Form(
                    key: _formKey_update_task,
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
                                  controller: update_task_title,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Task Title',
                                    hintText: 'Enter Task Title',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    errorText: _submitted ? _errorText1 : null,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Task Title can't be empty";
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
                                  controller: update_task_description,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Task Description',
                                    hintText: 'Enter Task Description',
                                    border: OutlineInputBorder(
                                        borderRadius: BorderRadius.circular(8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                  ),
                                  validator: (value) {
                                    if (value!.isEmpty) {
                                      return "Task Description can't be empty";
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
                                  if (_formKey_update_task.currentState!.validate()) {
                                    await _updateTask(widget.id);
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
                                child: const Text("Update Task"),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
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