import 'package:flutter/material.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';
import '../../widgets/assignmembers_dialog.dart';

class AddSubTaskPage extends StatefulWidget {
  const AddSubTaskPage({Key? key, required this.id}) : super(key: key);
  final id;

  @override
  State<AddSubTaskPage> createState() => _AddSubTaskPageState();
}

class _AddSubTaskPageState extends State<AddSubTaskPage> {
  final sub_task_title = TextEditingController();
  final sub_task_description = TextEditingController();
  List<String> _selectedItems = [];
  String people_data = '';
  int subtask_counter = 0;
  List<Map<String, dynamic>> _listMembers = [];
  List<String> members = [];
  final _formKey_sub_task = GlobalKey<FormState>();

  void loadMembers(int id) async {
    final data = await SQLHelper.getTask(id);
    setState(() {
      _listMembers = data;
      final subtask_data =
          _listMembers.firstWhere((element) => element['column_task_id'] == id);
      people_data = subtask_data['tasks_assigned_peoples']
          .replaceAll('[', '')
          .replaceAll(']', '');
      members = people_data.split(",");
    });
  }

  String _displayText(DateTime? date) {
    if (date != null) {
      return '${date.toString().split(' ')[0]}';
    } else {
      return 'Choose Deadline';
    }
  }

  final TextEditingController endDateController = TextEditingController();
  DateTime? endDate;

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }

  void _showMultiSelect() async {
    // a list of selectable items
    // these items can be hard-coded or dynamically fetched from a database/API

    final List<String>? results = await showDialog(
      context: this.context,
      builder: (BuildContext context) {
        return MultiSelect(items: members);
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
    loadMembers(widget.id);
    sub_task_title.text = "";
    sub_task_description.text = "";
    endDateController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text(
            'Add Sub Task',
            style: TextStyle(fontFamily: 'lato'),
          ),
          centerTitle: true,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(15),
              bottomLeft: Radius.circular(15),
            ),
          ),
          elevation: 0.0,
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
                  SizedBox(
                    height: 20.0,
                  ),
                  Form(
                    key: _formKey_sub_task,
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0, right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Title",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autofocus: false,
                                  cursorColor: Colors.grey[700],
                                  controller: sub_task_title,
                                  style: subtitleStyle,
                                  decoration: InputDecoration(
                                      hintText: "Enter Title",
                                      hintStyle: subtitleStyle,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0))),
                                  onChanged: (_) => setState(() {}),
                                )),
                              ]),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),

                            Text(
                              "Description",
                              style: titleStyle,
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                  maxLines: 4,
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autofocus: false,
                                  cursorColor: Colors.grey[700],
                                  controller: sub_task_description,
                                  style: subtitleStyle,
                                  decoration: InputDecoration(
                                      hintText: "Enter Description",
                                      hintStyle: subtitleStyle,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0))),
                                  onChanged: (_) => setState(() {}),
                                )),
                              ]),
                            ),

                            SizedBox(
                              height: 15.0,
                            ),
                            Text(
                              "Deadline",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(
                                      color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                  autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                  autofocus: false,
                                  readOnly: true,
                                  cursorColor: Colors.grey[700],
                                  controller: endDateController,
                                  style: subtitleStyle,
                                  decoration: InputDecoration(
                                      prefixIcon: Icon(
                                        Icons.calendar_month,
                                        color: Colors.grey,
                                      ),
                                      hintText: "Choose Deadline",
                                      hintStyle: subtitleStyle,
                                      focusedBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0)),
                                      enabledBorder: UnderlineInputBorder(
                                          borderSide: BorderSide(
                                              color: Colors.white, width: 0))),
                                  onTap: () async {
                                    endDate = await pickDate();
                                    endDateController.text =
                                        _displayText(endDate);
                                    setState(() {});
                                  },
                                  onChanged: (_) => setState(() {}),
                                )),
                              ]),
                            ),
                            SizedBox(
                              height: 15.0,
                            ),
                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              onPressed: _showMultiSelect,
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                      fontFamily: 'lato',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                    const Size(150, 50)),
                              ),
                              label: const Text('Assign Peoples'),
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
                                            style: TextStyle(
                                                fontFamily: 'lato',
                                                fontSize: 16.0),
                                          ),
                                        ),
                                      ))
                                  .toList(),
                            ),
                            ElevatedButton(
                              onPressed: () async {
                                if (sub_task_title.text.isEmpty ||
                                    sub_task_description.text.isEmpty ||
                                    endDateController.text.isEmpty) {
                                  showTopSnackBar(
                                    Overlay.of(context),
                                    const CustomSnackBar.error(
                                      message: 'All Fields are requiered',
                                    ),
                                  );
                                } else {
                                  await _addSubTask(widget.id);
                                  setState(() async {
                                    Navigator.pop(context, 'subtask');
                                  });
                                }
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(
                                      fontFamily: 'lato',
                                      fontSize: 20,
                                      color: Colors.white),
                                ),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(
                                    Size(wp(100, context), 50)),
                              ),
                              child: const Text("ADD Sub Task"),
                            ),
                          ]),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ));
  }

  // used to insert user input data to sub task table in database
  Future<void> _addSubTask(int id) async {
    String current_date = DateTime.now().toString();
    subtask_counter++;
    await SQLHelper.createSubTask(
        id,
        sub_task_title.text,
        sub_task_description.text,
        endDateController.text,
        _selectedItems.toString(),
        0,
        0.0,
        subtask_counter,
        current_date);
  }
}
