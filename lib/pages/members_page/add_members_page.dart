import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../databases/sql_helper.dart';
import '../../utils/responsive.dart';
import '../../utils/theme.dart';

class AddMembersPage extends StatefulWidget {
  const AddMembersPage({Key? key}) : super(key: key);
  @override
  State<AddMembersPage> createState() => _AddMembersPageState();
}

class _AddMembersPageState extends State<AddMembersPage> {

  TextEditingController member_name_Controller = TextEditingController();
  TextEditingController member_role_Controller = TextEditingController();
  TextEditingController member_mobileno_controller = TextEditingController();

  final _formKey_add_members = GlobalKey<FormState>();

  String people_data = '';
  String people_role = '';
  List<Map<String, dynamic>> _listProjects = [];

  // used for show alert for not null validation to user
  final snackBar = SnackBar(
    content:   Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),Text('All Fields are requiered', style: TextStyle(color: Color(0xFFff4667), fontFamily: 'lato' ),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  final phonesnackBar = SnackBar(
    content: Row(
      children: [
        Icon(
          Icons.warning_amber_rounded,
          color: Colors.red,
        ),
        Text('Enter Valid Phone No.',
          style: TextStyle(color: Color(0xFFff4667), fontFamily: 'lato'),),
      ],
    ),
    duration: Duration(seconds: 3),
    backgroundColor: Colors.white,
  );

  @override
  void initState() {
    super.initState();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        centerTitle: true,
        title: Text("Add Members", style: TextStyle(fontFamily: 'lato'),),
        backgroundColor: Colors.green,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            bottomRight: Radius.circular(15),
            bottomLeft: Radius.circular(15),
          ),
        ),
        elevation: 0.0,
      ),
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
                    key: _formKey_add_members,
                    child: Container(
                      padding: EdgeInsets.only(left: 20.0,right: 20.0),
                      child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Name",
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
                                      controller: member_name_Controller,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Name",
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
                              "Mobile No.",
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
                                      autofocus: false,
                                      keyboardType: TextInputType.number,
                                      cursorColor: Colors.grey[700],
                                      controller: member_mobileno_controller,
                                      inputFormatters: <TextInputFormatter>[
                                        // for below version 2 use this
                                        FilteringTextInputFormatter.allow(RegExp(r'^[+]*[(]{0,1}[0-9]{1,4}[)]{0,1}[-\s\./0-9]*$')),
                                        // for version 2 and greater youcan also use this
                                        FilteringTextInputFormatter.digitsOnly
                                      ],
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Mobile No.",
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
                              "Role",
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
                                      controller: member_role_Controller,
                                      style: subtitleStyle,
                                      decoration: InputDecoration(
                                          hintText: "Enter Role",
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
                            SizedBox(height: 20.0,),
                            ElevatedButton(
                              onPressed: () async {
                                if (member_name_Controller.text.isEmpty || member_mobileno_controller.text.isEmpty || member_role_Controller.text.isEmpty) {
                                  ScaffoldMessenger.of(context).showSnackBar(
                                      snackBar);
                                }else if(RegExp(r'^[0-9]{10}$').stringMatch(member_mobileno_controller.text) != null){
                                  await _addMembers();
                                  setState(() async {
                                    Navigator.pop(context);
                                    member_name_Controller.text = "";
                                    member_mobileno_controller.text = "";
                                    member_role_Controller.text = "";
                                  });
                                }
                                else{
                                  ScaffoldMessenger.of(context).showSnackBar(phonesnackBar);
                                }
                              },
                              style: ButtonStyle(
                                textStyle: MaterialStateProperty.all(
                                  TextStyle(fontSize: 20,color: Colors.white,fontFamily: 'lato'),),
                                shape: MaterialStateProperty.all(
                                  RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                                minimumSize: MaterialStateProperty.all(Size(wp(100, context), 50)),
                              ),
                              child: const Text("Add Member"),
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
  // used to insert user data to members table in database
  Future<void> _addMembers() async {
    await SQLHelper.createMembers(
        member_name_Controller.text, member_mobileno_controller.text, member_role_Controller.text);
  }
}
