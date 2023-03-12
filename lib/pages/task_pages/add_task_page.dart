import 'package:flutter/material.dart';
import '../../helpers/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../widgets/assignmembers_dialog.dart';

class AddTaskPage extends StatefulWidget {
  const AddTaskPage({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<AddTaskPage> createState() => _AddTaskPageState();
}

class _AddTaskPageState extends State<AddTaskPage> {
  final _formKey_task = GlobalKey<FormState>();
  final _task_title = TextEditingController();
  final _task_description = TextEditingController();
  List<String> _selectedItems = [];
  String people_data = '';

  String _displayText(String begin, DateTime? date) {
    if (date != null) {
      return '$begin ${date.toString().split(' ')[0]}';
    } else {
      return 'Choose The Date';
    }
  }

  final TextEditingController endDateController = TextEditingController();
  DateTime?  endDate;

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }



  String? endDateValidator(value) {

    if (endDate == null) return "select the date";
    return null; // optional while already return type is null
  }

  String? get _errorText1 {
    // at any time, we can get the text from _controller.value.text
    final text = _task_title.value.text;

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
    if (_errorText1 == null) {}
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
    _task_title.text = "";
    _task_description.text = "";
    endDateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Add Tasks'),
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
                  Image.asset(
                    'assets/images/tasks_image.jpg',
                    height: 200,
                    width: 300,
                  ),
                  Form(
                    key: _formKey_task,
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Container(
                        margin: EdgeInsets.only(left: 20.0, right: 20.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                            children: [
                              SizedBox(
                                width: wp(100, context),
                                child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _task_title,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Title',
                                    hintText: 'Enter Title',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
                                    fillColor: Colors.transparent,
                                    filled: true,
                                    errorText: _submitted ? _errorText1 : null,
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
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                width: wp(100, context),
                                child: TextFormField(
                                  maxLines: 4,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  controller: _task_description,
                                  decoration: InputDecoration(
                                    prefixIcon: Icon(
                                      Icons.edit_note,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Description',
                                    hintText: 'Enter Description',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                              SizedBox(
                                height: 15.0,
                              ),
                              SizedBox(
                                width: wp(100, context),
                                child: TextFormField(
                                  controller: endDateController,
                                  readOnly: true,
                                  decoration: InputDecoration(
                                    hintText: 'Choose Deadline',
                                    prefixIcon: Icon(
                                      Icons.calendar_today_outlined,
                                      color: Colors.grey,
                                    ),
                                    labelText: 'Deadline',
                                    border: OutlineInputBorder(
                                        borderRadius:
                                            BorderRadius.circular(8.0)),
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
                                      fontSize: 15, color: Colors.black),
                                ),
                              ),
                              SizedBox(
                                height: 15.0,
                              ),
                              Container(
                                alignment: Alignment.centerLeft,
                                child: ElevatedButton.icon(
                                  icon: Icon(Icons.add),
                                  onPressed: _showMultiSelect,
                                  style: ButtonStyle(
                                    textStyle: MaterialStateProperty.all(
                                      TextStyle(
                                          fontSize: 20, color: Colors.white),
                                    ),
                                    shape: MaterialStateProperty.all(
                                      RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                    ),
                                    minimumSize: MaterialStateProperty.all(
                                        const Size(150, 40)),
                                  ),
                                  label: const Text('Assign Peoples'),
                                ),
                              ),
                              SizedBox(
                                height: 10.0,
                              ),
                              // display selected items
                              Wrap(
                                children: _selectedItems
                                    .map((e) => Container(
                                          margin: EdgeInsets.only(
                                              left: 6.0, right: 6.0),
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
                                  if (_formKey_task.currentState!.validate()) {
                                    await _addTask(widget.id);
                                    setState(() async {
                                      Navigator.pop(context);
                                    });
                                  } else {
                                    // _formKey.currentState!.validate();
                                  }
                                },
                                style: ButtonStyle(
                                  textStyle: MaterialStateProperty.all(
                                    TextStyle(
                                        fontSize: 20, color: Colors.white),
                                  ),
                                  shape: MaterialStateProperty.all(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                  ),
                                  minimumSize: MaterialStateProperty.all(
                                      Size(wp(100, context), 50)),
                                ),
                                child: const Text("Add Task"),
                              ),
                            ]),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  Future<void> _addTask(int id) async {
    String current_date = DateTime.now().toString();
    // String data = json.encode(_selectedItems);
    await SQLHelper.createTask(id, _task_title.text, _task_description.text,
        endDateController.text,_selectedItems.toString(),0,0.0,current_date);
  }
}
