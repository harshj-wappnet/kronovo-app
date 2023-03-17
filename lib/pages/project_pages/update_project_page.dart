import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import '../../databases/sql_helper.dart';
import '../../utils/theme.dart';
import '../../widgets/assignmembers_dialog.dart';
import 'package:kronovo_app/utils/responsive.dart';

class UpdateProject extends StatefulWidget {
  final id;

  UpdateProject({super.key, required this.id});


  @override
  State<UpdateProject> createState() => UpdateProjectState();
}

class UpdateProjectState extends State<UpdateProject> {
  final _formKey_update_project = GlobalKey<FormState>();
  FocusNode searchFocusNode = FocusNode();
  FocusNode textFieldFocusNode = FocusNode();
  late MultiValueDropDownController cntMulti;
  late final ValueChanged<String> onSubmit;
  List<String> _selectedItems = [];
  String people_data = '';
  List<Map<String, dynamic>> _listProjects = [];
  List<String> _peoplesList = [];
  List<Map<String, dynamic>> _listMembers = [];
  List<String> members= [];

  void loadMembers() async {
    final data = await SQLHelper.getMembers();

    setState(() {
      _listMembers = data;
      List.generate(_listMembers.length, (index) => members.add(_listMembers[index]['members_name']));
    });
  }

  void getProjectData(int id) async {
    final data = await SQLHelper.getProjects();
    setState(() {
      _listProjects = data;
      String peoples = _listProjects[0]['project_assigned_peoples'].toString();
      _peoplesList = peoples.split(',');
      if (id != null) {
        final existingList = _listProjects.firstWhere((
            element) => element['project_id'] == id);
        update_project_title_Controller.text = existingList['project_name'];
        update_project_description_Controller.text =
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


  String _displayText(DateTime? date) {
    if (date != null) {
      return '${date.toString().split(' ')[0]}';
    } else {
      return 'Choose The Date';
    }
  }

  final TextEditingController startDateController = TextEditingController(),
      endDateController = TextEditingController();
  final update_project_title_Controller = TextEditingController();
  final update_project_description_Controller = TextEditingController();

  DateTime? startDate, endDate;

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: this.context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }


  @override
  void initState() {
    super.initState();
    getProjectData(widget.id);
    loadMembers();
    cntMulti = MultiValueDropDownController();
  }

  @override
  void dispose() {
    cntMulti.dispose();
    update_project_title_Controller.dispose();
    update_project_description_Controller.dispose();
    super.dispose();
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
        //_selectedItems.forEach((element) { people_data += element; people_data += ','; });
        //print(people_data);
      });
    }
  }

  final snackBar = SnackBar(
    content:   Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),Text('All Fields are requiered', style: TextStyle(color: Color(0xFFff4667)),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  final date_snackBar = SnackBar(
    content:   Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),Text('End date must be after startDate', style: TextStyle(color: Color(0xFFff4667)),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Update Project'),
        centerTitle: true,
        backgroundColor: Colors.green,
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
        child: SafeArea(
          child: SingleChildScrollView(
            child: Center(
              child: Column(
                children: [
                  SizedBox(height: 20.0,),
                  Form(
                    key: _formKey_update_project,
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0,right: 20.0),
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
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: update_project_title_Controller,
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
                                    )
                                ),
                              ]),
                            ),
                            SizedBox(height: 15.0,),

                            Text(
                              "Description",
                              style: titleStyle,
                            ),
                            Container(
                              height: 82,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      maxLines: 4,
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: update_project_description_Controller,
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
                                    )
                                ),
                              ]),
                            ),

                            SizedBox(height: 15.0,),


                            Text(
                              "Start Date",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: startDateController,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Choose Start Date",
                                          hintStyle: subtitleStyle,
                                          focusedBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white, width: 0)),
                                          enabledBorder: UnderlineInputBorder(
                                              borderSide: BorderSide(
                                                  color: Colors.white, width: 0))),
                                      onTap: () async {
                                        startDate = await pickDate();
                                        startDateController.text =
                                            _displayText(startDate);
                                        setState(() {});
                                      },
                                      readOnly: true,
                                      onChanged: (_) => setState(() {}),
                                    )
                                ),
                              ]),
                            ),

                            SizedBox(height: 15.0,),
                            Text(
                              "End Date",
                              style: titleStyle,
                            ),
                            Container(
                              height: 52,
                              margin: EdgeInsets.only(top: 8.0),
                              padding: EdgeInsets.only(left: 14),
                              decoration: BoxDecoration(
                                  border: Border.all(color: Colors.grey, width: 1.0),
                                  borderRadius: BorderRadius.circular(12)),
                              child: Row(children: [
                                Expanded(
                                    child: TextFormField(
                                      autovalidateMode:
                                      AutovalidateMode.onUserInteraction,
                                      autofocus: false,
                                      cursorColor: Colors.grey[700],
                                      controller: endDateController,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          prefixIcon: Icon(
                                            Icons.calendar_today_outlined,
                                            color: Colors.grey,
                                          ),
                                          hintText: "Choose End Date",
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
                                      readOnly: true,
                                      onChanged: (_) => setState(() {}),
                                    )
                                ),
                              ]),
                            ),

                            SizedBox(height: 15.0,),

                            ElevatedButton.icon(
                              icon: Icon(Icons.add),
                              onPressed: _showMultiSelect,
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20,color: Colors.white),),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(const Size(150, 50)),
                              ),
                              label: const Text('Assign Peoples'),
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
                                if (update_project_title_Controller.text.isEmpty || update_project_description_Controller.text.isEmpty || startDateController.text.isEmpty || endDateController.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar);
                                }else if(endDate!.isBefore(startDate!)){
                                  ScaffoldMessenger.of(context).showSnackBar(date_snackBar);
                                }else{
                                  await _updateProject(widget.id);
                                  setState((){
                                    Navigator.pop(context);
                                  });
                                }
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20,color: Colors.white),),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(Size(wp(100, context), 50)),
                              ),
                              child: const Text("Update Project"),
                            ),
                          ]),
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
        update_project_title_Controller.text,
        update_project_description_Controller.text,
        startDateController.text,
        endDateController.text,
        _selectedItems.toString(),
        current_date);
  }
}