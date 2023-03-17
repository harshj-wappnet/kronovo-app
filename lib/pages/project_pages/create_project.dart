import 'package:dropdown_textfield/dropdown_textfield.dart';
import 'package:flutter/material.dart';
import 'package:kronovo_app/utils/theme.dart';
import '../../databases/sql_helper.dart';
import '../../widgets/assignmembers_dialog.dart';
import 'package:kronovo_app/utils/responsive.dart';
import 'package:kronovo_app/pages/home_page.dart';

class CreateProject extends StatefulWidget {


  CreateProject({super.key});

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
  List<Map<String, dynamic>> _listMembers = [];
  List<String> members= [];



  void loadMembers() async {
    final data = await SQLHelper.getMembers();

    setState(() {
      _listMembers = data;
      List.generate(_listMembers.length, (index) => members.add(_listMembers[index]['members_name']));
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
  DateTime? startDate, endDate;

  Future<DateTime?> pickDate() async {
    return await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1999),
      lastDate: DateTime(2999),
    );
  }

  @override
  void initState() {
    super.initState();
    loadMembers();
    cntMulti = MultiValueDropDownController();
    startDateController.text = "";
    endDateController.text = "";
    project_title_Controller = TextEditingController();
    project_description_Controller = TextEditingController();
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
        title: Text('Create New Project'),
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
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20.0,),
                Form(
                  key: _formKey_project,
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
                                    controller: project_title_Controller,
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
                                    controller: project_description_Controller,
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
                                    cursorColor: Colors.grey[700],
                                    controller: endDateController,
                                    readOnly: true,
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
                              if (project_title_Controller.text.isEmpty || project_description_Controller.text.isEmpty || startDateController.text.isEmpty || endDateController.text.isEmpty) {
                                ScaffoldMessenger.of(context).showSnackBar(
                                    snackBar);
                              }else if(endDate!.isBefore(startDate!)){
                                ScaffoldMessenger.of(context).showSnackBar(date_snackBar);
                              }else{
                                await _addProject();
                                setState(() {
                                  Navigator.pop(context, 'update');
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
                            child: const Text("Create Project"),
                          ),
                        ]),
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
    await SQLHelper.createProject(project_title_Controller.text, project_description_Controller.text, startDateController.text, endDateController.text, _selectedItems.toString(),0.0,0,current_date);
  }
}
